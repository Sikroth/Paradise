
//////////////////////
//		Raw Meat	//
//////////////////////

/obj/item/reagent_containers/food/snacks/meat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
	health = 180
	filling_color = "#FF1C1C"
	bitesize = 3
	list_reagents = list("protein" = 3)

/obj/item/reagent_containers/food/snacks/meat/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/kitchen/knife) || istype(W, /obj/item/scalpel))
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		new /obj/item/reagent_containers/food/snacks/rawcutlet(src)
		to_chat(user, "You cut the meat in thin strips.")
		qdel(src)
	else
		..()

/obj/item/reagent_containers/food/snacks/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

/obj/item/reagent_containers/food/snacks/meat/human
	name = "-meat"
	var/subjectname = ""
	var/subjectjob = null

/obj/item/reagent_containers/food/snacks/meat/slab/meatproduct
	name = "meat product"
	desc = "A slab of station reclaimed and chemically processed meat product."

/obj/item/reagent_containers/food/snacks/meat/monkey
	//same as plain meat

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "Corgi meat"
	desc = "Tastes like... well you know..."

/obj/item/reagent_containers/food/snacks/meat/pug
	name = "Pug meat"
	desc = "Tastes like... well you know..."

/obj/item/reagent_containers/food/snacks/meat/ham
	name = "Ham"
	desc = "Taste like bacon."
	list_reagents = list("protein" = 3, "porktonium" = 10)

/obj/item/reagent_containers/food/snacks/meat/meatwheat
	name = "meatwheat clump"
	desc = "This doesn't look like meat, but your standards aren't <i>that</i> high to begin with."
	list_reagents = list("nutriment" = 3, "vitamin" = 2, "blood" = 5)
	filling_color = rgb(150, 0, 0)
	icon_state = "meatwheat_clump"
	bitesize = 4

/obj/item/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "rawcutlet"
	bitesize = 1
	list_reagents = list("protein" = 1)

/obj/item/reagent_containers/food/snacks/rawcutlet/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/kitchen/knife))
		user.visible_message( \
			"[user] cuts the raw cutlet with the knife!", \
			"<span class ='notice'>You cut the raw cutlet with your knife!</span>" \
			)
		new /obj/item/reagent_containers/food/snacks/raw_bacon(loc)
		qdel(src)

/obj/item/reagent_containers/food/snacks/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#DB0000"
	bitesize = 3
	list_reagents = list("protein" = 12, "morphine" = 5, "vitamin" = 2)

/obj/item/reagent_containers/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of meat."
	icon_state = "xenomeat"
	filling_color = "#43DE18"
	bitesize = 6
	list_reagents = list("protein" = 3, "vitamin" = 1)

/obj/item/reagent_containers/food/snacks/spidermeat
	name = "spider meat"
	desc = "A slab of spider meat."
	icon_state = "spidermeat"
	bitesize = 3
	list_reagents = list("protein" = 3, "toxin" = 3, "vitamin" = 1)

/obj/item/reagent_containers/food/snacks/lizardmeat
	name = "mutant lizard meat"
	desc = "Seems to be a slab of meat from some mutant lizard thing?"
	icon_state = "xenomeat"
	filling_color = "#43DE18"
	bitesize = 3
	list_reagents = list("protein" = 3, "toxin" = 3)

/obj/item/reagent_containers/food/snacks/spiderleg
	name = "spider leg"
	desc = "A still twitching leg of a giant spider... you don't really want to eat this, do you?"
	icon_state = "spiderleg"
	list_reagents = list("protein" = 2, "toxin" = 2)

/obj/item/reagent_containers/food/snacks/raw_bacon
	name = "raw bacon"
	desc = "It's fleshy and pink!"
	icon_state = "raw_bacon"
	list_reagents = list("nutriment" = 1, "porktonium" = 10)

/obj/item/reagent_containers/food/snacks/spidereggs
	name = "spider eggs"
	desc = "A cluster of juicy spider eggs. A great side dish for when you care not for your health."
	icon_state = "spidereggs"
	list_reagents = list("protein" = 2, "toxin" = 2)

//////////////////////
//	Cooked Meat		//
//////////////////////

/obj/item/reagent_containers/food/snacks/meatsteak
	name = "Meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"
	bitesize = 3
	list_reagents = list("nutriment" = 5)

/obj/item/reagent_containers/food/snacks/bacon
	name = "bacon"
	desc = "It looks juicy and tastes amazing!"
	icon_state = "bacon2"
	list_reagents = list("nutriment" = 4, "porktonium" = 10, "msg" = 4)

/obj/item/reagent_containers/food/snacks/telebacon
	name = "Tele Bacon"
	desc = "It tastes a little odd but it is still delicious."
	icon_state = "bacon"
	var/obj/item/radio/beacon/bacon/baconbeacon
	list_reagents = list("nutriment" = 4, "porktonium" = 10)

/obj/item/reagent_containers/food/snacks/telebacon/New()
	..()
	baconbeacon = new /obj/item/radio/beacon/bacon(src)

/obj/item/reagent_containers/food/snacks/telebacon/On_Consume(mob/M, mob/user)
	if(!reagents.total_volume)
		baconbeacon.loc = user
		baconbeacon.digest_delay()

/obj/item/reagent_containers/food/snacks/meatball
	name = "Meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	filling_color = "#DB0000"
	list_reagents = list("protein" = 4, "vitamin" = 1)

/obj/item/reagent_containers/food/snacks/sausage
	name = "Sausage"
	desc = "A piece of mixed, long meat."
	icon_state = "sausage"
	filling_color = "#DB0000"
	list_reagents = list("protein" = 6, "vitamin" = 1, "porktonium" = 10)

/obj/item/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "cutlet"
	list_reagents = list("protein" = 2)

/obj/item/reagent_containers/food/snacks/spidereggsham
	name = "green eggs and ham"
	desc = "Would you eat them on a train? Would you eat them on a plane? Would you eat them on a state of the art corporate deathtrap floating through space?"
	icon_state = "spidereggsham"
	trash = /obj/item/trash/plate
	bitesize = 4
	list_reagents = list("nutriment" = 6)

/obj/item/reagent_containers/food/snacks/boiledspiderleg
	name = "boiled spider leg"
	desc = "A giant spider's leg that's still twitching after being cooked. Gross!"
	icon_state = "spiderlegcooked"
	trash = /obj/item/trash/plate
	bitesize = 3
	list_reagents = list("nutriment" = 3, "capsaicin" = 2)

/obj/item/reagent_containers/food/snacks/wingfangchu
	name = "Wing Fang Chu"
	desc = "A savory dish of alien wing wang in soy."
	icon_state = "wingfangchu"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#43DE18"
	list_reagents = list("nutriment" = 6, "soysauce" = 5, "vitamin" = 2)


//////////////////////
//		Cubes		//
//////////////////////

/obj/item/reagent_containers/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#ADAC7F"
	var/datum/species/monkey_type = /datum/species/monkey
	list_reagents = list("nutriment" = 2)

/obj/item/reagent_containers/food/snacks/monkeycube/water_act(volume, temperature)
	if(volume >= 5)
		return Expand()

/obj/item/reagent_containers/food/snacks/monkeycube/wash(mob/user, atom/source)
	user.drop_item()
	forceMove(get_turf(source))
	return 1

/obj/item/reagent_containers/food/snacks/monkeycube/proc/Expand()
	if(!QDELETED(src))
		visible_message("<span class='notice'>[src] expands!</span>")
		if(fingerprintslast)
			log_game("Cube ([monkey_type]) inflated, last touched by: " + fingerprintslast)
		else
			log_game("Cube ([monkey_type]) inflated, last touched by: NO_DATA")
		var/mob/living/carbon/human/creature = new /mob/living/carbon/human(get_turf(src))
		if(LAZYLEN(fingerprintshidden))
			creature.fingerprintshidden = fingerprintshidden.Copy()
		creature.set_species(monkey_type)
		qdel(src)

/obj/item/reagent_containers/food/snacks/monkeycube/farwacube
	name = "farwa cube"
	monkey_type = /datum/species/monkey/tajaran

/obj/item/reagent_containers/food/snacks/monkeycube/wolpincube
	name = "wolpin cube"
	monkey_type = /datum/species/monkey/vulpkanin

/obj/item/reagent_containers/food/snacks/monkeycube/stokcube
	name = "stok cube"
	monkey_type = /datum/species/monkey/unathi

/obj/item/reagent_containers/food/snacks/monkeycube/neaeracube
	name = "neaera cube"
	monkey_type = /datum/species/monkey/skrell


//////////////////////
//		Eggs		//
//////////////////////

/obj/item/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	filling_color = "#FDFFD1"
	list_reagents = list("protein" = 1, "egg" = 5)

/obj/item/reagent_containers/food/snacks/egg/throw_impact(atom/hit_atom)
	..()
	var/turf/T = get_turf(hit_atom)
	new/obj/effect/decal/cleanable/egg_smudge(T)
	if(reagents)
		reagents.reaction(hit_atom, TOUCH)
	qdel(src)

/obj/item/reagent_containers/food/snacks/egg/attackby(obj/item/W, mob/user, params)
	if(istype( W, /obj/item/toy/crayon ))
		var/obj/item/toy/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			to_chat(usr, "<span class ='notice'>The egg refuses to take on this color!</span>")
			return

		to_chat(usr, "<span class ='notice'>You color \the [src] [clr]</span>")
		icon_state = "egg-[clr]"
		item_color = clr
	else
		..()

/obj/item/reagent_containers/food/snacks/egg/blue
	icon_state = "egg-blue"
	item_color = "blue"

/obj/item/reagent_containers/food/snacks/egg/green
	icon_state = "egg-green"
	item_color = "green"

/obj/item/reagent_containers/food/snacks/egg/mime
	icon_state = "egg-mime"
	item_color = "mime"

/obj/item/reagent_containers/food/snacks/egg/orange
	icon_state = "egg-orange"
	item_color = "orange"

/obj/item/reagent_containers/food/snacks/egg/purple
	icon_state = "egg-purple"
	item_color = "purple"

/obj/item/reagent_containers/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"
	item_color = "rainbow"

/obj/item/reagent_containers/food/snacks/egg/red
	icon_state = "egg-red"
	item_color = "red"

/obj/item/reagent_containers/food/snacks/egg/yellow
	icon_state = "egg-yellow"
	item_color = "yellow"

/obj/item/reagent_containers/food/snacks/friedegg
	name = "Fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	filling_color = "#FFDF78"
	bitesize = 1
	list_reagents = list("nutriment" = 3, "egg" = 5)

/obj/item/reagent_containers/food/snacks/boiledegg
	name = "Boiled egg"
	desc = "A hard boiled egg."
	icon_state = "egg"
	filling_color = "#FFFFFF"
	list_reagents = list("nutriment" = 2, "egg" = 5, "vitamin" = 1)

/obj/item/reagent_containers/food/snacks/chocolateegg
	name = "Chocolate Egg"
	desc = "Such sweet, fattening food."
	icon_state = "chocolateegg"
	filling_color = "#7D5F46"
	list_reagents = list("nutriment" = 4, "sugar" = 2, "cocoa" = 2)

/obj/item/reagent_containers/food/snacks/omelette
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	icon_state = "omelette"
	trash = /obj/item/trash/plate
	filling_color = "#FFF9A8"
	list_reagents = list("nutriment" = 8, "vitamin" = 1)
	bitesize = 1

/obj/item/reagent_containers/food/snacks/benedict
	name = "eggs benedict"
	desc = "There is only one egg on this, how rude."
	icon_state = "benedict"
	bitesize = 3
	list_reagents = list("nutriment" = 6, "egg" = 3, "vitamin" = 4)


//////////////////////
//		Misc		//
//////////////////////

/obj/item/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "Fresh footlong ready to go down on."
	icon_state = "hotdog"
	bitesize = 3
	list_reagents = list("nutriment" = 6, "ketchup" = 3, "vitamin" = 3)

/obj/item/reagent_containers/food/snacks/meatbun
	name = "meat bun"
	desc = "Has the potential to not be dog."
	icon_state = "meatbun"
	bitesize = 6
	list_reagents = list("nutriment" = 6, "vitamin" = 2)

/obj/item/reagent_containers/food/snacks/sliceable/turkey
	name = "Turkey"
	desc = "A traditional turkey served with stuffing."
	icon_state = "turkey"
	slice_path = /obj/item/reagent_containers/food/snacks/turkeyslice
	slices_num = 6
	list_reagents = list("protein" = 24, "nutriment" = 18, "vitamin" = 5)

/obj/item/reagent_containers/food/snacks/turkeyslice
	name = "turkey serving"
	desc = "A serving of some tender and delicious turkey."
	icon_state = "turkeyslice"
	trash = /obj/item/trash/plate
	filling_color = "#B97A57"

/obj/item/reagent_containers/food/snacks/organ
	name = "organ"
	desc = "It's good for you."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#E00D34"
	bitesize = 3
	list_reagents = list("protein" = 4, "vitamin" = 4)

/obj/item/reagent_containers/food/snacks/appendix
//yes, this is the same as meat. I might do something different in future
	name = "appendix"
	desc = "An appendix which looks perfectly healthy."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#E00D34"
	bitesize = 3
	list_reagents = list("protein" = 3, "vitamin" = 2)

/obj/item/reagent_containers/food/snacks/appendix/inflamed
	name = "inflamed appendix"
	desc = "An appendix which appears to be inflamed."
	icon_state = "appendixinflamed"
	filling_color = "#E00D7A"
