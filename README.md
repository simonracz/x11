# How to debug make

1. `make -d`
2. Print out variables with helper.mak `make -f Makefile -f helper.mak print-X`

helper.mak
```
print-%:
	@echo $* = $($*)
```

