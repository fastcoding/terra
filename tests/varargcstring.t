C = terralib.includec("stdio.h")
C.printf("hello, %d,%s\n",terralib.new(int,3),'astring')
