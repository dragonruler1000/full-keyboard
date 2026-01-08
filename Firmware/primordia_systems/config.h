// I2C Configuration
#define I2C_DRIVER I2CD0
#define I2C1_SDA_PIN GP0
#define I2C1_SCL_PIN GP1

// MCP23017 Configuration
#define MCP23017_I2C_ADDRESS 0x20  // Default address, adjust if different

// Encoder pins on MCP23017
// Encoder 0: GPB0 (A), GPB1 (B)
// Encoder 1: GPB2 (A), GPB3 (B)
#define ENCODERS_PAD_A { GPB1, GPB3 }
#define ENCODERS_PAD_B { GPB0, GPB2 }
#define ENCODER_RESOLUTION 4
