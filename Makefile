SRCDIR := $(CURDIR)/src
BUILDDIR := $(CURDIR)/build
BINARY := main

.PHONY:
all: debug

.PHONY:
debug: FLAGS = -DDEBUG -g
debug: $(BINARY)

.PHONY:
release: FLAGS = -O2 -march=native -mtune=native
release: $(BINARY)

SOURCES := $(shell find $(SRCDIR) -name \*.cpp)
HEADERS := $(shell find $(SRCDIR) -name \*.h)
OBJECTS := $(addprefix $(BUILDDIR)/, $(notdir $(SOURCES:.cpp=.o)))
DIRS := $(dir $(SOURCES))
INCLUDES := $(foreach dir, $(dir $(HEADERS)), $(addprefix -I, $(dir)))
VPATH := $(DIRS)

CFLAGS = $(FLAGS) -Wall -Wextra -std=c17
CXXFLAGS = $(FLAGS) -Wall -Wextra -std=c++17
#LDFLAGS := 
LDLIBS := -lm

$(BINARY): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(OBJECTS): $(BUILDDIR)/%o: $(SRCDIR)/%cpp $(HEADERS) | $(BUILDDIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $@ -c $<

$(BUILDDIR):
	mkdir $(BUILDDIR)

.PHONY:
clean:
	$(RM) $(OBJECTS) $(BINARY)
	$(RM) -d $(BUILDDIR)
