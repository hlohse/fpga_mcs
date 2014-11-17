################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
ELFSIZE += \
test1.elf.size \

ELFCHECK += \
test1.elf.elfcheck \


# All Target
all: test1.elf secondary-outputs

# Tool invocations
test1.elf: $(OBJS) ../src/lscript.ld $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: MicroBlaze gcc linker'
	mb-gcc -Wl,--gc-sections -Wl,-T -Wl,../src/lscript.ld -L../../mcs_bsp_0/mblaze/lib -mlittle-endian -mcpu=v8.40.a -mxl-soft-mul -o "test1.elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

test1.elf.size: test1.elf
	@echo 'Invoking: MicroBlaze Print Size'
	mb-size test1.elf  |tee "test1.elf.size"
	@echo 'Finished building: $@'
	@echo ' '

test1.elf.elfcheck: test1.elf
	@echo 'Invoking: Xilinx ELF Check'
	elfcheck test1.elf -hw ../../mcs_hw/system.xml -pe mblaze  |tee "test1.elf.elfcheck"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) $(OBJS)$(C_DEPS)$(EXECUTABLES)$(ELFSIZE)$(ELFCHECK)$(S_UPPER_DEPS) test1.elf
	-@echo ' '

secondary-outputs: $(ELFSIZE) $(ELFCHECK)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
