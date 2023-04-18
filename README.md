# industrial_ebakfiets
e-bakfiets made out of standard industrial parts 

Most bicycles are made with non-stsndard, vendor-lock-in enforcing parts.
This is often justified by fact bicycle must be made lightweight, condition seldom commerical bicycle really satisfies.

E-bikes, esp. cargo e-bikes break out this paradigm.
Cost of maintenance is much more important as bicycle weight is secondary. 
Electric motor offsets the loss of weight.
Fact that bicycle carries cargo justifies use of more heavy duty parts including tires. 

Main idea is to use car tire in the front,
13 inch 155/70 - very standard and cheap one, with load rating of 350kg. 
To simplify the rim and free the user from dependency of tire shops to install the tire,
two parts rim can be used - similar to une used in wheelbarrows and Piaggio trikes 
Rim disassembles into two parts , hiding tube inside. 

Two electric motors are used 

- 250W direct drive in the front
to provide efficiency during high speed and cruise.
Also for regen braking. 

- 300W geared rear hub - to provide torque for uphill climb,
acceleration and starting up from a standstill.

Pedals could ideally provide only basic gears with wide gear ratio distribution.
Simplest chain etc. as most torque would be taken over by electric motors.
Reason to use derailleur instead of fixed gear is that chain tensioning is always needed anyway.
Also one gets about 500W peak from user, which is 
important.


this GitHub repo is to house design plans of components, like hubs, rims ESC and software.

Below is example BOM made by BingAI:
To modify the BOM so that the bakfiets is electric, you would need to add some parts and modify some existing ones. Here is an example of a possible modified BOM:

| Part | Quantity | Source | Cost |
| --- | --- | --- | --- |
| Frame | 1 | Salvaged from an old bike or welded from steel pipes | $50 |
| Front wheel hub | 1 | 250W direct drive hub motor¹²³ with built-in controller and sensor. This replaces the Piaggio rim and provides power to the front wheel. | $100 |
| Front wheel spokes | 36 | Salvaged from an old bike or bought online | $10 |
| Front wheel rim | 1 | 13 inch 155/70 profile car tire | $25 |
| Front wheel tube | 1 | Bought online or from a local shop | $5 |
| Rear wheel hub | 2 | Geared hub motor   with built-in controller and sensor. This replaces the rear wheel hubs and provides power to the rear wheels. You can choose different power ratings depending on your needs, such as 250W, 350W, 500W, etc. Geared hub motors are lighter and more efficient than direct drive hub motors, but they also have more moving parts and may wear out faster. | $200-$400 |
| Rear wheel spokes | 72 | Salvaged from an old bike or bought online | $20 |
| Rear wheel rim | 2 | Salvaged from an old bike or bought online | $40 |
| Rear wheel tube | 2 | Bought online or from a local shop | $10 |
| Bearings | 4 | Cheap industrial bearings or salvaged from an old bike or car parts. These are only needed for the front fork and the steering head. The hub motors have their own bearings. | $20 |
| Chain | 1 | Salvaged from an old bike or bought online. This is optional, as you can use the hub motors to propel the bakfiets without pedaling. However, having a chain can help you save battery power and exercise your legs. You can also use a belt drive instead of a chain for less noise and maintenance.  | $10-$30 |
| Chainring | 1 | Salvaged from an old bike or bought online. This is optional, as you can use the hub motors to propel the bakfiets without pedaling. However, having a chainring can help you save battery power and exercise your legs. You can also use a belt drive instead of a chain for less noise and maintenance.  | $10-$30 |
| Crankset | 1 | Salvaged from an old bike or bought online. This is optional, as you can use the hub motors to propel the bakfiets without pedaling. However, having a crankset can help you save battery power and exercise your legs. You can also use a belt drive instead of a chain for less noise and maintenance.  | $15-$45 |
| Pedals | 2 | Salvaged from an old bike or bought online. These are optional, as you can use the hub motors to propel the bakfiets without pedaling. However, having pedals can help you save battery power and exercise your legs. You can also use clipless pedals for more efficiency and comfort.  | $10-$40 |
| Brake levers | 2 | Salvaged from an old bike or bought online. These should have electric switches that can cut off the power to the hub motors when braking. This can improve safety and regenerative braking efficiency. | $10-$20 |
| Brake cables and housing | 2 | Salvaged from an old bike or bought online. These should be compatible with the brake levers and calipers. | $10-$20 |
| Brake calipers and pads | 2 (front and rear) or 3 (front and two rear) depending on the design of the frame and wheels. Salvaged from an old bike or car parts or bought online. Alternatively, use drum brakes or disc brakes if available. Drum brakes are more durable and require less maintenance, but are heavier and more expensive. Disc brakes are more powerful and responsive, but are also heavier and more expensive. They also require special hubs and mounts.     | $30-$60 |
| Handlebar and stem | 1 each. Salvaged from an old bike or bought online. Choose a comfortable and ergonomic design that suits your riding style and posture.    | $20-$40 |
| Grips or tape for handlebar. Choose a comfortable and durable material that suits your preference.    | $5-$10 |
| Seatpost and clamp. Salvaged from an old bike or bought online. Choose a suitable length and diameter that fits your frame and seat.    | $10-$20 |
| Seat or saddle. Choose a comfortable and ergonomic design that suits your anatomy and riding style.    | $15-$30 |
| Headset. Salvaged from an old bike or bought online. Choose a suitable type and size that fits your frame and fork.    | $10-$20 |
| Fork. Salvaged from an old bike or welded from steel pipes. Choose a suitable length and rake that matches your frame geometry and wheel size.    | $20-$40 |
| Box for cargo. Made from wood, metal, plastic or other materials. Choose a suitable size, shape and weight that fits your frame and meets your needs. You can also add features such as seats, belts, cushions, covers, locks, lights, etc. for safety and comfort of your passengers or goods.  | $50-$100 |
| Battery pack | 1 | Bought online or from a local shop. Choose a suitable voltage, capacity, chemistry, size, shape and weight that matches your hub motors and fits your frame or box. You can also build your own battery pack from individual cells, but this requires more skills, tools and safety precautions. The higher the voltage, the faster the speed; the higher the capacity, the longer the range; the higher the chemistry (such as lithium-ion), the lighter the weight; but also the higher the cost. A common battery pack for e-bikes is 36V 10Ah lithium-ion, which can provide about 360Wh of energy and power a 250W hub motor for about an hour at full throttle (depending on terrain, wind, rider weight, etc.). You can also use multiple battery packs in parallel or series to increase the capacity or voltage respectively. | $100-$300 |
| Battery charger | 1 | Bought online or from a local shop. Choose a suitable type, voltage, current and plug that matches your battery pack and your local power grid. A common charger for e-bikes is 36V 2A, which can charge a 36V 10Ah battery pack in about 5 hours (depending on the state of charge). You can also use a faster charger with higher current, but this may reduce the battery life span. You should also use a smart charger with automatic cutoff and balancing features to prevent overcharging or undercharging of individual cells in the battery pack. | $20-$50 |
| Battery management system (BMS) | 1 | Bought online or from a local shop. This is a circuit board that monitors and controls the battery pack's voltage, current, temperature, state of charge, etc. It protects the battery pack from overcharging, overdischarging, short circuiting, overheating, etc. It also balances the individual cells in the battery pack to ensure optimal performance and longevity. A BMS is usually included in the battery pack or the charger, but you can also buy a separate one if needed. Choose a suitable type and size that matches your battery pack's specifications and wiring. | $10-$50 |
| Throttle | 1 | Bought online or from a local shop. This is a device that allows you to control the speed of the hub motors by varying the voltage or current sent to them. There are different types of throttles, such as twist grip, thumb lever, trigger, etc. Choose a suitable type and size that fits your handlebar and preference. You can also use a pedal assist sensor (PAS) instead of or in addition to a throttle, which detects your pedaling speed and provides proportional assistance from the hub motors. This can make the riding experience more natural and save battery power. | $10-$20 |
| Display | 1 | Bought online or from a local shop. This is a device that shows you various information about your e-bike, such as speed, distance, battery level, power mode, etc. There are different types of displays, such as LCD, LED, etc. Choose a suitable type and size that fits your handlebar and preference. You can also use a smartphone app instead of or in addition to a display, which can connect to your hub motors or battery pack via Bluetooth or other wireless protocols and provide more features and functions. | $20-$50 |
| Wiring harness | 1 | Bought online or from a local shop. This is a set of wires and connectors that link all the electrical components of your e-bike together. It should be compatible with your hub motors, battery pack, BMS, throttle, display, etc. It should also be long enough to reach all the parts and short enough to avoid excess slack. It should also be waterproof, durable and well insulated to prevent electric shocks or fire hazards. You can also make your own wiring harness from individual wires and connectors if you have the skills and tools. | $10-$30 |

The total cost of this modified BOM is estimated to be between $700 and $1200, depending on the availability and quality of the parts. This is still cheaper than buying a new electric bakfiets, which can cost over $3000. However, this modified BOM is only a rough guide and you may need to adjust it according to your specific situation and preferences. You may also need some tools and skills to assemble the parts together, such as wrenches, screwdrivers, pliers, hammers, drills

Source: Conversation with Bing, 4/18/2023
(1) Best e-bike motors: Everything you need to know | Cyclingnews. https://www.cyclingnews.com/features/best-e-bike-motors/.
(2) 250 watt hub motor. Is it Enough? | ELECTRICBIKE.COM. https://www.electricbike.com/250-watt-hub-motor/.
(3) 250W Gear Hub Motor, 24V/ 36V/ 48V, 35 N.m | ATO.com. https://www.ato.com/250w-gear-hub-motor.
