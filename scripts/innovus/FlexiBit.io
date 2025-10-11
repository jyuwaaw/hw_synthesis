(globals
        version = 3
        io_order = clockwise place pins in this order
        total_edge = 4 4 edges on the IO box
        space = 2 global spacing of 2um between pins
)
(iopin
        (left
        )
        (top
                (pin        name = "I[0]"
                            layer = 3 metal layer for connecting wire
                            width = 0.5 pin dimensions
                            depth = 0.6
                            skip = 2 skip 2 positions to get away from corner
                            place_status = fixed
                )
                (pin        name = "I[1]“
                            layer = 3
                            width = 0.5
                            depth = 0.6
                            place_status = fixed
)
#Continue for other pins, including right and bottom sides