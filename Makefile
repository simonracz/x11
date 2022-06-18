SRCDIR := $(CURDIR)/src
BUILDDIR := $(CURDIR)/build
BINARY := main

.PHONY: all debug release clean

all: debug

FLAGS = -MMD -MP

debug: FLAGS += -DDEBUG -g
debug: $(BINARY)

release: FLAGS += -O2 -march=native -mtune=native
release: $(BINARY)

SOURCES := $(shell find $(SRCDIR) -name \*.cpp)
HEADERS := $(shell find $(SRCDIR) -name \*.h)
DEPENDS := $(addprefix $(BUILDDIR)/, $(notdir $(SOURCES:.cpp=.d)))
OBJECTS := $(addprefix $(BUILDDIR)/, $(notdir $(SOURCES:.cpp=.o)))
DIRS := $(dir $(SOURCES))
INCLUDES := $(foreach dir, $(dir $(HEADERS)), $(addprefix -I, $(dir)))
VPATH := $(DIRS)

CFLAGS = $(FLAGS) -Wall -Wextra -std=c17
CXXFLAGS = $(FLAGS) -Wall -Wextra -std=c++17
#LDFLAGS := 
#LDLIBS := -lm

-include $(DEPENDS)

$(BINARY): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(OBJECTS): $(BUILDDIR)/%o: $(SRCDIR)/%cpp Makefile | $(BUILDDIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $@ -c $<

$(BUILDDIR):
	mkdir $(BUILDDIR)

clean:
	$(RM) $(OBJECTS) $(BINARY) $(DEPENDS)
	$(RM) -d $(BUILDDIR)
