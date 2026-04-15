# Assembly Guide: Industrial E-Bakfiets

This guide outlines the recommended sequence for assembling the Industrial E-Bakfiets. It assumes all custom parts (frame, fork, adapters) have been fabricated according to the specifications in the `docs/modules/` and `docs/drawings/` folders.

## Phase 1: Frame and Fork Preparation
1. **Deburring**: Ensure all laser-cut edges and tube ends are deburred.
2. **Head Tube**: Press the 7202 Angular Contact bearings into the steering head.
3. **Alignment Check**: Ensure the rear dropouts are parallel (135mm spacing) and the front fork crown is square to the steering axis.
4. **Painting**: Apply industrial-grade powder coating or anti-corrosive primer and paint.

## Phase 2: Front Wheel & Hub Assembly
1. **Motor Adapters**: Bolt the 12mm adapter plates to the Golden Motor Magic Pie 5 spoke flanges using 24x M5x20mm Grade 12.9 bolts (12 per side). Use Blue Loctite.
2. **Rim Sandwich**: Place the 13-inch tire and tube between the two rim halves. Sandwich this assembly between the two adapter plates.
3. **Fastening**: Pass the 6x M8x140mm Grade 10.9 bolts through the entire assembly. Tighten in a star pattern to **30Nm**.
4. **Disc Rotor**: Install the 203mm rotor using M5 bolts (6-bolt ISO).

## Phase 3: Steering and Cockpit
1. **Steering Shaft**: Slide the 15mm shaft through the head tube bearings. Secure with the 35mm OD locking collars.
2. **Handlebars**: Install the adjustable stem and 720mm bars.
3. **Linkage**: Connect the steering bell cranks using the 15mm tie-rod and M10 rod ends. Adjust for zero toe-in.

## Phase 4: Drivetrain and Brakes
1. **Bottom Bracket**: Install the square-taper BB and 170mm cranks.
2. **Rear Wheel**: Install the 16-inch geared hub motor wheel into the rear dropouts.
3. **Chain**: Route the chain through the derailleur. Ensure proper tensioning.
4. **Braking**: Mount the hydraulic calipers. Bleed the lines and ensure the 203mm (front) and 180mm (rear) rotors have centered clearance.

## Phase 5: Electrical Integration
1. **Battery Mount**: Secure the dual LiFePO4 packs under the cargo bed spars using heavy-duty straps or custom enclosures.
2. **Controllers**: Mount the front and rear controllers in the waterproof enclosures.
3. **Wiring**: Route the main 48V bus and the signal Y-splitter. Use spiral wrap or PA6 tubing for protection.
4. **Supervisory Controller**: (Optional) Install the ESP32/Arduino system monitor in the cockpit.

## Phase 6: Final Commissioning
1. **Static Test**: Check all bolt torques (especially M14 axle nuts and M8 rim bolts).
2. **Power Up**: Test throttle response on a bike stand (wheels off ground).
3. **Brake Test**: Ensure e-brake cutoffs function on both motors.
4. **Load Test**: Perform a low-speed test ride with 50kg of cargo to check for frame flex or linkage binding.
