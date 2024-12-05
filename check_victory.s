# To anyone trying to read this file : i am deeply sorry and i hope you survive after going through this. good luck

# We want to be able to call check_victory from main, so expose it to the linker
    .global check_victory

    .text   # program section (r)


# Check if a player won, and store the result in rax
check_victory:
    # Clear the registers (hopefully they don't store something important lol)
    mov     $0, %rax
    mov     $0, %rbx
    mov     $0, %rcx

    # Check all rows
    call check_row_1
    cmp     $0, %rax
    jne _check_victory_exit
    call check_row_2
    cmp     $0, %rax
    jne _check_victory_exit
    call check_row_3
    cmp     $0, %rax
    jne _check_victory_exit

    # Check all columns
    call check_column_1
    cmp     $0, %rax
    jne _check_victory_exit
    call check_column_2
    cmp     $0, %rax
    jne _check_victory_exit
    call check_column_3
    cmp     $0, %rax
    jne _check_victory_exit

    # Check diagonals
    call check_diagonal_1
    cmp     $0, %rax
    jne _check_victory_exit
    call check_diagonal_2
    cmp     $0, %rax
    jne _check_victory_exit

_check_victory_exit:
    ret



check_row_1:
    mov     $grid_data, %rdx        # Address of first line

    movb    (%rdx), %bl             # Get the first cell
    cmp     $0, %bl                 # If the first cell is empty then we don't need to check the other ones
    je _check_row_1_exit

    inc     %rdx                    # Go to next cell
    movb    (%rdx), %cl             # Get second cell
    cmp     %bl, %cl                # If the first & second cells are different then we know there are no winners
    jne _check_row_1_exit

    inc     %rdx                    # Go to next cell
    movb    (%rdx), %cl             # Get third cell
    cmp     %bl, %cl                # If it is different than the first one then there are no winners
    jne _check_row_1_exit

    mov     %bl, %al                # If we get here then the line is filled by the same player, so store the player in the low byte of rax

_check_row_1_exit:
    ret


check_row_2:
    mov     $(grid_data+3), %rdx    # Address of second line

    movb    (%rdx), %bl             # Get the first cell
    cmp     $0, %bl                 # If the first cell is empty then we don't need to check the other ones
    je _check_row_2_exit

    inc     %rdx                    # Go to next cell
    movb    (%rdx), %cl             # Get second cell
    cmp     %bl, %cl                # If the first & second cells are different then we know there are no winners
    jne _check_row_2_exit

    inc     %rdx                    # Go to next cell
    movb    (%rdx), %cl             # Get third cell
    cmp     %bl, %cl                # If it is different than the first one then there are no winners
    jne _check_row_2_exit

    mov     %bl, %al                # If we get here then the line is filled by the same player, so store the player in the low byte of rax

_check_row_2_exit:
    ret


check_row_3:
    mov     $(grid_data+6), %rdx    # Address of third line

    movb    (%rdx), %bl             # Get the first cell
    cmp     $0, %bl                 # If the first cell is empty then we don't need to check the other ones
    je _check_row_3_exit

    inc     %rdx                    # Go to next cell
    movb    (%rdx), %cl             # Get second cell
    cmp     %bl, %cl                # If the first & second cells are different then we know there are no winners
    jne _check_row_3_exit

    inc     %rdx                    # Go to next cell
    movb    (%rdx), %cl             # Get third cell
    cmp     %bl, %cl                # If it is different than the first one then there are no winners
    jne _check_row_3_exit

    mov     %bl, %al                # If we get here then the line is filled by the same player, so store the player in the low byte of rax

_check_row_3_exit:
    ret


check_column_1:
    mov     $grid_data, %rdx        # Address of first column

    movb    (%rdx), %bl             # Get the first cell
    cmp     $0, %bl                 # If the first cell is empty then we don't need to check the other ones
    je _check_column_1_exit

    add     $3, %rdx                # Go to next cell
    movb    (%rdx), %cl             # Get second cell
    cmp     %bl, %cl                # If the first & second cells are different then we know there are no winners
    jne _check_column_1_exit

    add     $3, %rdx                # Go to next cell
    movb    (%rdx), %cl             # Get third cell
    cmp     %bl, %cl                # If it is different than the first one then there are no winners
    jne _check_column_1_exit

    mov     %bl, %al                # If we get here then the column is filled by the same player, so store the player in the low byte of rax

_check_column_1_exit:
    ret


check_column_2:
    mov     $(grid_data+1), %rdx    # Address of second column

    movb    (%rdx), %bl             # Get the first cell
    cmp     $0, %bl                 # If the first cell is empty then we don't need to check the other ones
    je _check_column_2_exit

    add     $3, %rdx                # Go to next cell
    movb    (%rdx), %cl             # Get second cell
    cmp     %bl, %cl                # If the first & second cells are different then we know there are no winners
    jne _check_column_2_exit

    add     $3, %rdx                # Go to next cell
    movb    (%rdx), %cl             # Get third cell
    cmp     %bl, %cl                # If it is different than the first one then there are no winners
    jne _check_column_2_exit

    mov     %bl, %al                # If we get here then the column is filled by the same player, so store the player in the low byte of rax

_check_column_2_exit:
    ret


check_column_3:
    mov     $(grid_data+2), %rdx    # Address of third column

    movb    (%rdx), %bl             # Get the first cell
    cmp     $0, %bl                 # If the first cell is empty then we don't need to check the other ones
    je _check_column_3_exit

    add     $3, %rdx                # Go to next cell
    movb    (%rdx), %cl             # Get second cell
    cmp     %bl, %cl                # If the first & second cells are different then we know there are no winners
    jne _check_column_3_exit

    add     $3, %rdx                # Go to next cell
    movb    (%rdx), %cl             # Get third cell
    cmp     %bl, %cl                # If it is different than the first one then there are no winners
    jne _check_column_3_exit

    mov     %bl, %al                # If we get here then the column is filled by the same player, so store the player in the low byte of rax

_check_column_3_exit:
    ret


check_diagonal_1:
    mov     $grid_data, %rdx        # Address of first cell

    movb    (%rdx), %bl             # Get the first cell
    cmp     $0, %bl                 # If the first cell is empty then we don't need to check the other ones
    je _check_diagonal_1_exit

    add     $4, %rdx                # Go to next cell
    movb    (%rdx), %cl             # Get second cell
    cmp     %bl, %cl                # If the first & second cells are different then we know there are no winners
    jne _check_diagonal_1_exit

    add     $4, %rdx                # Go to next cell
    movb    (%rdx), %cl             # Get third cell
    cmp     %bl, %cl                # If it is different than the first one then there are no winners
    jne _check_diagonal_1_exit

    mov     %bl, %al                # If we get here then the diagonal is filled by the same player, so store the player in the low byte of rax

_check_diagonal_1_exit:
    ret


check_diagonal_2:
    mov     $(grid_data+2), %rdx      # Address of first cell

    movb    (%rdx), %bl             # Get the first cell
    cmp     $0, %bl                 # If the first cell is empty then we don't need to check the other ones
    je _check_diagonal_2_exit

    add     $2, %rdx                # Go to next cell
    movb    (%rdx), %cl             # Get second cell
    cmp     %bl, %cl                # If the first & second cells are different then we know there are no winners
    jne _check_diagonal_2_exit

    add     $2, %rdx                # Go to next cell
    movb    (%rdx), %cl             # Get third cell
    cmp     %bl, %cl                # If it is different than the first one then there are no winners
    jne _check_diagonal_2_exit

    mov     %bl, %al                # If we get here then the diagonal is filled by the same player, so store the player in the low byte of rax

_check_diagonal_2_exit:
    ret
