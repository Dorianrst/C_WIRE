CC = gcc


SRCDIR = src/C_WIRE-main
INCDIR = include/setting.h
BINDIR = bin/c_wire.exe

SOURCES = $(wildcard $(SRCDIR)/*.c)
HEADERS = $(wildcard $(INCDIR)/*.h)
OBJECTS = $(patsubst $(SRCDIR)/%.c, $(BINDIR)/%.o, $(SOURCES))
EXECUTABLE = $(BINDIR)

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@ $(LFLAGS)

$(BINDIR)/%.o: $(SRCDIR)/%.c $(HEADERS)
	$(CC) -c $< -o $@

run: $(EXECUTABLE)
	$(EXECUTABLE)

clean:
	rm -f $(OBJECTS) $(EXECUTABLE)
