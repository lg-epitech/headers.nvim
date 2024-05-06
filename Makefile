##
## EPITECH PROJECT, 2024
## headers.nvim
## File description:
## Makefile
##

# WARN: This Makefile is for the convenience of running tests
# DO NOT RUN WITHOUT CHANGING THE PROPER TEMPLATES DIR IN EACH FILE

all: test_all

test_all:
	nvim --headless -c "PlenaryBustedDirectory spec/"

test_templates:
	nvim --headless -c "PlenaryBustedFile spec/templates_spec.lua"

.PHONY:	test_all
