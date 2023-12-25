    .global _start

    .text   # program section (r)


flush_stdin:
    # read(stdin, trash, 1)
    mov     $0, %rax                                                # 0 : sys_read
    mov     $0, %rdi                                                # 0 : stdin
    mov     $trash, %rsi                                            # address of trash
    mov     $1, %rdx                                                # length
    syscall

    movb    trash, %al
    cmpb    $'\n', %al
    je      _exit_flush_stdin                                       # Keep flushing until we reach a new line
    jmp     flush_stdin
_exit_flush_stdin:
    ret



reinitialize:
    mov     $current_player, %rax                                   # The first player to play is player 1
    movb    $1, (%rax)

    mov     $grid_data, %rax                                        # Load address of grid
_reinitialize_clear_single_value:
    movb    $0, (%rax)                                              # Put 0 in current cell
    inc     %rax                                                    # Go to next cell
    cmp     $grid_data_end, %rax
    jl      _reinitialize_clear_single_value                        # Keep clearing until we reach the end of the grid

    mov     $grid_message, %rax                                     # Load address of the grid string
    mov     $grid_message_original, %rsi                            # Load address of the original grid string
_reinitialize_reset_grid_message:
    movb    (%rsi), %dl                                             # Copy the original into the r/w version
    movb    %dl, (%rax)
    inc     %rax                                                    # Go to next character
    inc     %rsi
    cmp     $grid_message_end, %rax
    jl      _reinitialize_reset_grid_message                        # Keep copying until we reach the end of the gird string

    ret



# Okay, so here is the plan for this one : don't use rax and rdx, because they are impacted by the division
# We use rbx/bl to prepare a character for the grid and as the divisor (3).
# We use rcx for keeping track of where we are in the grid
# and rsi for keeping track of where we are in the message.
# Then, we use rdi as a counter and to keep track of multiples of 3 (aka switching lines)
update_grid_string:
    mov     $grid_data, %rcx                                        # Pos in grid
    mov     $grid_message, %rsi                                     # Pos in message
    mov     $0, %rdi                                                # Index (number of iterations, idk)

_update_grid_string_loop:
    movb    (%rcx), %bl                                             # Get the value at current cell (0, 1 or 2)
    cmpb    $1, %bl                                                 # Check if player 1 have the cell (put an X)
    je      _put_x
    cmpb    $2, %bl                                                 # Check if player 2 have the cell (put an O)
    je      _put_o
    jmp     _divide_grid_index_by_3                                 # If this is reached, no players have the cell (put nothing)
_put_x:
    movb    $'X', %bl
    jmp     _put_character_in_grid
_put_o:
    movb    $'O', %bl

_put_character_in_grid:
    movb    %bl, (%rsi)

_divide_grid_index_by_3:
    mov     %rdi, %rax                                              # Prepare dividing the current index
    mov     $3, %rbx                                                # ...by 3
    mov     $0, %rdx                                                # Clear previous remainder if necessary
    div     %rbx                                                    # Divide by rbx (3) (remainder in rdx)
    cmp     $2, %rdx                                                # Check if the number mod 3 is 2
    je _mod2_by_3
    add $2, %rsi                                                    # If not, increase by 2 the position in message
    jmp _update_grid_string_loop_next
_mod2_by_3:
    add $8, %rsi                                                    # If so, increase by 8 the position in message
_update_grid_string_loop_next:
    inc     %rcx                                                    # Go to next cell
    inc     %rdi                                                    # Increase iteration index
    cmp     $9, %rdi                                                # We need to keep iterating 9 times
    jl _update_grid_string_loop
    ret



_start:
    call reinitialize

prompt:
    # write(stdout, grid_message, len(grid_message))
    mov     $1, %rax                                                # 1 : sys_write
    mov     $1, %rdi                                                # 1 : stdout
    mov     $grid_message, %rsi                                     # address of grid message
    mov     $(grid_message_end-grid_message), %rdx                  # length
    syscall

    # write(stdout, number_prompt, len(number_prompt))
    mov     $1, %rax                                                # 1 : sys_write
    mov     $1, %rdi                                                # 1 : stdout
    mov     $number_prompt, %rsi                                    # address of string to output
    mov     $(number_prompt_end-number_prompt), %rdx                # length
    syscall

    # read(stdin, user_in, 1)
    mov     $0, %rax                                                # 0 : sys_read
    mov     $0, %rdi                                                # 0 : stdin
    mov     $user_in, %rsi                                          # address of user_in
    mov     $1, %rdx                                                # length
    syscall  

    movb    user_in, %al
    cmpb $'\n', %al                                                 # If the user enter an empty line then we don't need to flush
    je _continue_user_check
    call flush_stdin
_continue_user_check:
    mov     $0, %rax                                                # Clear rax, and reload al (in the case flush_strdin was called)
    movb    user_in, %al
    cmpb    $'1', %al
    jl      prompt                                                  # User input is too low
    cmpb    $'9', %al
    jg      prompt                                                  # ...or too high


    sub     $48, %al                                                # Convert ascii to number
    dec     %al                                                     # The number of the first cell is 1, so subtract by 1
    add     $grid_data, %rax                                        # Find correct address

    movb    (%rax), %bl                                             # Check if the cell is already occupied
    cmpb    $0, %bl
    jg      prompt                                                  # If so, re-ask for a value
    movb    current_player, %bl                                     # If not, we can put the value (yay)
    movb    %bl, (%rax)

    call    update_grid_string                                      # Update the grid

    movb    current_player, %al                                     # Get the value of the current player, and set it to the other one
    cmp     $1, %al
    je _give_turn_to_p2
    movb    $1, %al
    movb    %al, current_player
    jmp _check_victory
_give_turn_to_p2:
    movb    $2, %al
    movb    %al, current_player


_check_victory:
    # TODO : check victory lmao

    jmp prompt


_prog_exit:
    # exit(0)
    mov     $60, %rax               # 60 : sys_exit
    xor     %rdi, %rdi              # return 0
    syscall



number_prompt:
    .ascii  "Enter a number : "
number_prompt_end:

# Used for resetting
grid_message_original:
    .ascii "1|2|3\n-----\n4|5|6\n-----\n7|8|9\n"
grid_message_original_end:



    .data   # r/w memory section

# The message to display each time we want to display the grid
grid_message:
    .ascii "1|2|3\n-----\n4|5|6\n-----\n7|8|9\n"
grid_message_end:

# Cells of the grid (0 : empty, 1 : X, 2 : O)
grid_data:
    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0
grid_data_end:

# The last value entered by the user
user_in:
    .byte 0

# Determine who is the player currently playing (1 or 2)
current_player:
    .byte 1

# Used for flushing stdin
trash:
    .byte 0
