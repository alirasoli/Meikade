
wasm {
    QMAKE_WASM_TOTAL_MEMORY = 33554432
    QMAKE_LFLAGS += -s \"BINARYEN_TRAP_MODE=\'clamp\'\" 
}