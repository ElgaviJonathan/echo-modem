################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/echo_transmitter_test.cpp 

C_SRCS += \
../src/SystemCore.c \
../src/dec2bin.c \
../src/echo_transmitter.c \
../src/echo_transmitter_data.c \
../src/echo_transmitter_emxutil.c \
../src/echo_transmitter_initialize.c \
../src/echo_transmitter_terminate.c \
../src/multi_tone_fsk_modulator.c \
../src/rtGetInf.c \
../src/rtGetNaN.c \
../src/rt_nonfinite.c 

CPP_DEPS += \
./src/echo_transmitter_test.d 

C_DEPS += \
./src/SystemCore.d \
./src/dec2bin.d \
./src/echo_transmitter.d \
./src/echo_transmitter_data.d \
./src/echo_transmitter_emxutil.d \
./src/echo_transmitter_initialize.d \
./src/echo_transmitter_terminate.d \
./src/multi_tone_fsk_modulator.d \
./src/rtGetInf.d \
./src/rtGetNaN.d \
./src/rt_nonfinite.d 

OBJS += \
./src/SystemCore.o \
./src/dec2bin.o \
./src/echo_transmitter.o \
./src/echo_transmitter_data.o \
./src/echo_transmitter_emxutil.o \
./src/echo_transmitter_initialize.o \
./src/echo_transmitter_terminate.o \
./src/echo_transmitter_test.o \
./src/multi_tone_fsk_modulator.o \
./src/rtGetInf.o \
./src/rtGetNaN.o \
./src/rt_nonfinite.o 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c src/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: Cygwin C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.cpp src/subdir.mk
	@echo 'Building file: $<'
	@echo 'Invoking: Cygwin C++ Compiler'
	g++ -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


clean: clean-src

clean-src:
	-$(RM) ./src/SystemCore.d ./src/SystemCore.o ./src/dec2bin.d ./src/dec2bin.o ./src/echo_transmitter.d ./src/echo_transmitter.o ./src/echo_transmitter_data.d ./src/echo_transmitter_data.o ./src/echo_transmitter_emxutil.d ./src/echo_transmitter_emxutil.o ./src/echo_transmitter_initialize.d ./src/echo_transmitter_initialize.o ./src/echo_transmitter_terminate.d ./src/echo_transmitter_terminate.o ./src/echo_transmitter_test.d ./src/echo_transmitter_test.o ./src/multi_tone_fsk_modulator.d ./src/multi_tone_fsk_modulator.o ./src/rtGetInf.d ./src/rtGetInf.o ./src/rtGetNaN.d ./src/rtGetNaN.o ./src/rt_nonfinite.d ./src/rt_nonfinite.o

.PHONY: clean-src

