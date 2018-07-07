#define DIRECTION_FORWARDS	1
#define DIRECTION_OFF		0
#define DIRECTION_REVERSED	-1

GLOBAL_LIST_INIT(conveyor_belts, list()) //Saves us having to look through the entire machines list for our things
GLOBAL_LIST_INIT(conveyor_switches, list())

//conveyor2 is pretty much like the original, except it supports corners, but not diverters.
//note that corner pieces transfer stuff clockwise when running forward, and anti-clockwise backwards.

/obj/machinery/conveyor
	icon = 'icons/obj/recycling.dmi'
	icon_state = "conveyor_stopped_cw"
	name = "conveyor belt"
	desc = "A conveyor belt."
	layer = 2			// so they appear under stuff
	anchored = TRUE
	var/operating = FALSE
	var/forwards			// The direction the conveyor sends you in
	var/backwards			// hopefully self-explanatory
	var/clockwise = TRUE	// For corner pieces - do we go clockwise or counterclockwise?
	var/operable = TRUE			// Can this belt actually go?
	var/list/affecting		// the list of all items that will be moved this ptick
	var/reversed = FALSE	// set to TRUE to have the conveyor belt be reversed
	speed_process = TRUE	//gotta go fast
	var/id				//ID of the connected lever

	// create a conveyor
/obj/machinery/conveyor/New(loc, new_dir, new_id)
	..(loc)
	GLOB.conveyor_belts += src
	if(new_id)
		id = new_id
	if(new_dir)
		dir = new_dir
	update_move_direction()
	for(var/I in GLOB.conveyor_switches)
		var/obj/machinery/conveyor_switch/S = I
		if(id == S.id)
			S.conveyors += src

/obj/machinery/conveyor/Destroy()
	GLOB.conveyor_belts -= src
	return ..()

/obj/machinery/conveyor/setDir(newdir)
	. = ..()
	update_move_direction()

// attack with item, place item on conveyor
/obj/machinery/conveyor/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/crowbar))
		if(!(stat & BROKEN))
			var/obj/item/conveyor_construct/C = new(loc)
			C.id = id
			transfer_fingerprints_to(C)
		playsound(loc, I.usesound, 50, 1)
		to_chat(user,"<span class='notice'>You remove the conveyor belt.</span>")
		qdel(src)
	else if(stat & BROKEN)
		return ..()
	else if(istype(I, /obj/item/wrench))
		set_rotation(user)
		update_move_direction()
		playsound(loc, I.usesound, 50, 1)
	else if(istype(I, /obj/item/conveyor_switch_construct))
		var/obj/item/conveyor_switch_construct/S = I
		id = S.id
		to_chat(user, "<span class='notice'>You link [I] with [src].</span>")
	else if(user.a_intent != INTENT_HARM)
		if(user.drop_item())
			I.forceMove(loc)
	else
		return ..()

// attack with hand, move pulled object onto conveyor
/obj/machinery/conveyor/attack_hand(mob/user as mob)
	user.Move_Pulled(src)

/obj/machinery/conveyor/update_icon()
	..()
	if(operating && can_conveyor_run())
		icon_state = "conveyor_started_[clockwise ? "cw" : "ccw"]"
		if(reversed)
			icon_state += "_r"
	else
		icon_state = "conveyor_stopped_[clockwise ? "cw" : "ccw"]"

/obj/machinery/conveyor/proc/update_move_direction() //NB: Direction refers to the space an item will end up in if it moves onto a space e.g. NORTHEAST = transfer an item to the northeast. clockwise affects the icon and refers to the way the belt appears to travel.
	update_icon()
	if(dir in cardinal)
		forwards = reversed ? turn(dir, 180) : dir
		backwards = reversed ? dir : turn(dir, 180)
	else
		forwards = turn(dir, clockwise ? -45 : 45)
		backwards = turn(forwards, clockwise ? -90 : 90)
		if(!reversed)
			return
		var/temporary_direction = forwards
		forwards = backwards
		backwards = temporary_direction

/obj/machinery/conveyor/proc/set_rotation(mob/user)
	dir = turn(reversed ? backwards : forwards, -90) //Fuck it, let's do it this way instead of doing something clever with dir
	var/turf/left = get_step(src, turn(dir, 90))	//We need to get conveyors to the right, left, and behind this one to be able to determine if we need to make a corner piece
	var/turf/right = get_step(src, turn(dir, -90))
	var/turf/back = get_step(src, turn(dir, 180))
	to_chat(user, "<span>You rotate [src].</span>")
	var/obj/machinery/conveyor/CL = locate() in left
	var/obj/machinery/conveyor/CR = locate() in right
	var/obj/machinery/conveyor/CB = locate() in back
	var/link_to_left = FALSE
	var/link_to_right = FALSE
	var/link_to_back = FALSE
	if(CL)
		if(CL.id == id && get_step(CL, CL.reversed ? CL.backwards : CL.forwards) == loc)
			link_to_left = TRUE
	if(CR)
		if(CR.id == id && get_step(CR, CR.reversed ? CR.backwards : CR.forwards) == loc)
			link_to_right = TRUE
	if(CB)
		if(CB.id == id && get_step(CB, CB.reversed ? CB.backwards : CB.forwards) == loc)
			link_to_back = TRUE
	if(link_to_back) //Don't need to do anything because we can assume the conveyor carries on in a line
		return
	else if(link_to_left && link_to_right) //Two conveyors are pointed to this one, they will both drop items on here so we don't need to do anything (this will be the middle piece in a "junction"
		return
	else if(link_to_left || link_to_right) //There is one conveyor pointed to us, so we need to make a corner piece
		if(CR)
			dir = turn(dir, 45)
			clockwise = TRUE
		else if(CL)
			dir = turn(dir, -45)
			clockwise = FALSE

/obj/machinery/conveyor/power_change()
	..()
	process()
	update_icon()

/obj/machinery/conveyor/process()
	if(!operating)
		return
	if(!can_conveyor_run())
		return
	use_power(100)
	affecting = loc.contents - src // moved items will be all in loc
	if(!affecting)
		return
	sleep(1)
	for(var/atom/movable/A in affecting)
		if(!A.anchored)
			if(A.loc == loc) // prevents the object from being affected if it's not currently here.
				step(A,forwards)
		CHECK_TICK

/obj/machinery/conveyor/proc/can_conveyor_run()
	if(stat & BROKEN)
		return FALSE
	else if(stat & NOPOWER)
		return FALSE
	else if(!operable)
		return FALSE
	return TRUE

// make the conveyor broken and propagate inoperability to any connected conveyor with the same conveyor datum
/obj/machinery/conveyor/proc/make_broken()
	stat |= BROKEN
	operable = FALSE
	update_icon()
	var/obj/machinery/conveyor/C = locate() in get_step(src, forwards)
	if(C)
		C.set_operable(TRUE, id, FALSE)
	C = locate() in get_step(src, backwards)
	if(C)
		C.set_operable(FALSE, id, FALSE)

//set the operable var if conveyor ID matches, propagating in the given direction

/obj/machinery/conveyor/proc/set_operable(propagate_forwards, match_id, op)
	if(id != match_id)
		return
	operable = op
	update_icon()
	var/obj/machinery/conveyor/C = locate() in get_step(src, propagate_forwards ? forwards : backwards)
	if(C)
		C.set_operable(propagate_forwards ? TRUE : FALSE, id, op)

// the conveyor control switch

/obj/machinery/conveyor_switch
	name = "conveyor switch"
	desc = "A conveyor control switch."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch-off"
	var/position = DIRECTION_OFF
	var/reversed = TRUE
	var/one_way = FALSE	// Do we go in one direction?
	anchored = TRUE
	speed_process = TRUE
	var/id
	var/list/conveyors = list()

/obj/machinery/conveyor_switch/New(newloc, new_id)
	..(newloc)
	GLOB.conveyor_switches += src
	if(!id)
		id = new_id
	for(var/I in GLOB.conveyor_belts)
		var/obj/machinery/conveyor/C = I
		if(C.id == id)
			conveyors += C

/obj/machinery/conveyor_switch/Destroy()
	GLOB.conveyor_switches -= src
	return ..()

// update the icon depending on the position

/obj/machinery/conveyor_switch/update_icon()
	overlays.Cut()
	if(!position)
		icon_state = "switch-off"
	else if(position == DIRECTION_REVERSED)
		icon_state = "switch-rev"
		if(!(stat & NOPOWER))
			overlays += "redlight"
	else if(position == DIRECTION_FORWARDS)
		icon_state = "switch-fwd"
		if(!(stat & NOPOWER))
			overlays += "greenlight"

/obj/machinery/conveyor_switch/oneway
	one_way = TRUE

// attack with hand, switch position
/obj/machinery/conveyor_switch/attack_hand(mob/user)
	if(..())
		return TRUE
	toggle(user)

/obj/machinery/conveyor_switch/attack_ghost(mob/user)
	if(user.can_advanced_admin_interact())
		toggle(user)

/obj/machinery/conveyor_switch/proc/toggle(mob/user)
	if(!allowed(user) && !user.can_advanced_admin_interact()) //this is in Para but not TG. I don't think there's any which are set anyway.
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	add_fingerprint(user)
	if(position)
		position = DIRECTION_OFF
	else
		reversed = one_way ? FALSE : !reversed
		position = reversed ? DIRECTION_REVERSED : DIRECTION_FORWARDS
	update_icon()
	var/make_go = position ? TRUE : FALSE //Do the check here so we don't need to do it a bunch of times later
	var/make_go_reverse = reversed ? TRUE : FALSE
	for(var/obj/machinery/conveyor/C in conveyors)
		C.operating = make_go
		if(C.reversed != make_go_reverse)
			C.reversed = make_go_reverse
			C.update_move_direction()
		else
			C.update_icon()
		CHECK_TICK
	for(var/I in GLOB.conveyor_switches) // find any switches with same id as this one, and set their positions to match us
		var/obj/machinery/conveyor_switch/S = I
		if(S == src || S.id != id)
			continue
		S.position = position
		S.one_way = one_way //Break everything!!1!
		S.reversed = reversed
		S.update_icon()
		CHECK_TICK

/obj/machinery/conveyor_switch/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/crowbar))
		var/obj/item/conveyor_switch_construct/C = new(loc, id)
		transfer_fingerprints_to(C)
		to_chat(user,"<span class='notice'>You detach the conveyor switch.</span>")
		qdel(src)
	else if(istype(I, /obj/item/multitool))
		update_multitool_menu(user)
	else
		return ..()

/obj/machinery/conveyor_switch/multitool_topic(var/mob/user,var/list/href_list,var/obj/O)
	..()
	if("toggle_logic" in href_list)
		one_way = !one_way
		update_multitool_menu(user)

/obj/machinery/conveyor_switch/multitool_menu(var/mob/user, var/obj/item/multitool/P)
	return {"
 	<ul>
 	<li><b>One direction only:</b> <a href='?src=[UID()];toggle_logic=1'>[one_way ? "On" : "Off"]</a></li>
 	</ul>"}

/obj/machinery/conveyor_switch/power_change()
	..()
	update_icon()

// CONVEYOR CONSTRUCTION STARTS HERE

/obj/item/conveyor_construct
	icon = 'icons/obj/recycling.dmi'
	icon_state = "conveyor_loose"
	name = "conveyor belt assembly"
	desc = "A conveyor belt assembly."
	w_class = WEIGHT_CLASS_BULKY
	var/id

/obj/item/conveyor_construct/attackby(obj/item/I, mob/user, params)
	..()
	if(!istype(I, /obj/item/conveyor_switch_construct))
		return
	var/obj/item/conveyor_switch_construct/C = I
	to_chat(user, "<span class='notice'>You link [src] to [C].</span>")
	id = C.id

/obj/item/conveyor_construct/afterattack(turf/T, mob/user, proximity)
	if(!proximity)
		return
	if(user.incapacitated())
		return
	if(!istype(T, /turf/simulated/floor))
		return
	if(T == get_turf(user))
		to_chat(user, "<span class='notice'>You cannot place a conveyor belt under yourself.</span>")
		return
	if(locate(/obj/machinery/conveyor) in T)
		to_chat(user, "<span class='notice'>There's already a conveyor there!</span>")
		return
	var/obj/machinery/conveyor/C = new(T, user.dir, id)
	transfer_fingerprints_to(C)
	qdel(src)

/obj/item/conveyor_switch_construct
	name = "conveyor switch assembly"
	desc = "A conveyor control switch assembly."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch"
	w_class = WEIGHT_CLASS_BULKY
	var/id

/obj/item/conveyor_switch_construct/New(loc, new_id)
	..(loc)
	if(new_id)
		id = new_id
	else
		id = world.time + rand() //this couldn't possibly go wrong


/obj/item/conveyor_switch_construct/afterattack(turf/T, mob/user, proximity)
	if(!proximity)
		return
	if(user.incapacitated())
		return
	if(!istype(T, /turf/simulated/floor))
		return
	var/found = FALSE
	for(var/obj/machinery/conveyor/C in view())
		if(C.id == id)
			found = TRUE
			break
	if(!found)
		to_chat(user, "<span class='notice'>[src] did not detect any linked conveyor belts in range.</span>")
		return
	var/obj/machinery/conveyor_switch/NC = new(T, id)
	transfer_fingerprints_to(NC)
	qdel(src)

/obj/item/conveyor_switch_construct/attackby(obj/item/I, mob/user)
	if(!istype(I, /obj/item/conveyor_switch_construct))
		return ..()
	var/obj/item/conveyor_switch_construct/S = I
	id = S.id
	to_chat(user, "<span class='notice'>You link the two switch constructs.</span>")

/obj/item/paper/conveyor
	name = "paper- 'Nano-it-up U-build series, #9: Build your very own conveyor belt, in SPACE'"
	info = "<h1>Congratulations!</h1><p>You are now the proud owner of the best conveyor set available for space mail order! We at Nano-it-up know you love to prepare your own structures without wasting time, so we have devised a special streamlined assembly procedure that puts all other mail-order products to shame!</p><p>Firstly, you need to link the conveyor switch assembly to each of the conveyor belt assemblies. After doing so, you simply need to install the belt assemblies onto the floor, et voila, belt built. Our special Nano-it-up smart switch will detected any linked assemblies as far as the eye can see! </p><p> Set single directional switches by using your multitool on the switch after you've installed the switch assembly.</p><p> This convenience, you can only have it when you Nano-it-up. Stay nano!</p>"

/obj/machinery/conveyor/counterclockwise
	clockwise = FALSE
	icon_state = "conveyor_stopped_ccw"

/obj/machinery/conveyor/auto/New(loc, newdir)
	..(loc, newdir)
	operating = TRUE
	update_icon()

#undef DIRECTION_FORWARDS
#undef DIRECTION_OFF
#undef DIRECTION_REVERSED
