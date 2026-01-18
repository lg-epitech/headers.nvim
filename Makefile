##
## EPITECH PROJECT, 2024
## headers.nvim
## File description:
## Makefile
##

all: tests

tests:
	nvim --headless -c "PlenaryBustedDirectory spec/" +qa

utils:
	nvim --headless -c "PlenaryBustedFile spec/utils_spec.lua" +qa

.PHONY:	tests
