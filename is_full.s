# We want to be able to call is_full from main, so expose it to the linker
    .global is_full

    .text   # program section (r)


# Put rax to 1 if the grid is full, 0 otherwise
is_full:
    mov     $0, %rax                # Assume the grid is not full
    mov     $0, %rbx
    mov     $grid_data, %rdx

_is_full_loop:
    movb    (%rdx), %bl             # Get current cell

    cmp     $0, %bl                 # If we encounter a 0 then the grid is not full...
    je     _is_full_exit            #... so we can return 0

    inc     %rdx                    # Go no next cell
    cmp     $(grid_data+9), %rdx    # Check if we reached the end of the grid
    jne _is_full_loop               # If not continue to iterate

    mov $1, %rax                    # If we get here then the grid is full

_is_full_exit:
    ret
