# Parallel Implementation of Conway's Game of Life #

This repository contains a parallel implementation of __John Conway's Game of Life__ A.K.A __Life__ using MPI and CUDA

### Rule Set for Game of Life ###

count => number of neighbouring cells whose state := "on"

1. **Death** : '''Python
                  if count < 2 or count > 3 :
                      cell.state = "off" ''''

2. **Survival** :'''Python
                  'if count == 2 or count == 3 :
                      if cell.state == on':
                            cell.state = "unchanged" '''

3. **Birth** : '''Python
                'if cell.state == "off and count == 3 :
                      cell.state = "on" '''

### References ###

[Game of Life Cellular Automata](http://download.springer.com/static/pdf/50/bok%253A978-1-84996-217-9.pdf?originUrl=http%3A%2F%2Flink.springer.com%2Fbook%2F10.1007%2F978-1-84996-217-9&token2=exp=1488644798~acl=%2Fstatic%2Fpdf%2F50%2Fbok%25253A978-1-84996-217-9.pdf%3ForiginUrl%3Dhttp%253A%252F%252Flink.springer.com%252Fbook%252F10.1007%252F978-1-84996-217-9*~hmac=606357a51ed8501f8404d07a3f5b9854e73f84959d3967c72fbf4a6eca086a11)

[Wolfram - Cellular Automata](http://mathworld.wolfram.com/GameofLife.html)
