msg_stage2:         db  'Entering stage 2, enabling A20 line.', 0
msg_enable1:        db  'A20 line already enabled.', 0
msg_enable2:        db  'A20 line enabled by BIOS call.', 0
msg_enable3:        db  'A20 line enabled by keyboard controller.', 0
msg_enable4:        db  'A20 line enabled by fast A20 enable.', 0
msg_failed:         db  'A20 line could not be enabled, halting.', 0

msg_list:           dw  msg_failed
                    dw  msg_enable1
                    dw  msg_enable2
                    dw  msg_enable3
                    dw  msg_enable4