as ./main.s -o main.o
as ./check_victory.s -o check_victory.o
as ./is_full.s -o is_full.o
ld ./main.o ./check_victory.o ./is_full.o
./a.out