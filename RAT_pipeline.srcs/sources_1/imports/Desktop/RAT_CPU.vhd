----------------------------------------------------------------------------------
-- Module:   RAT_CPU
-- Engineer: Kyle Wuerch & Chin Chao
-- Comments: This module is the upper level module that connects the
--           control unit, reg_file, alu, flags, scr, sp, prog_rom, and pc
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity RAT_CPU is
    Port ( IN_PORT    : in  STD_LOGIC_VECTOR (7 downto 0);
           RST        : in  STD_LOGIC;
           CLK        : in  STD_LOGIC;
           INT_IN     : in  STD_LOGIC;
           OUT_PORT   : out  STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID    : out  STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB    : out  STD_LOGIC);
end RAT_CPU;

architecture Behavioral of RAT_CPU is

   component stage1 is
       Port ( 
          CLK     : in  STD_LOGIC;
          S1_EN       : in STD_LOGIC;
          S1_EN_2       : in STD_LOGIC;
--          PC_INC      : in  STD_LOGIC;
          PC_LD       : in  STD_LOGIC;
          RST         : in  STD_LOGIC;
          PC_MUX_SEL  : in  STD_LOGIC_VECTOR (1 downto 0);
          FROM_IMMED  : in  STD_LOGIC_VECTOR (9 downto 0);
          FROM_STACK  : in  STD_LOGIC_VECTOR (9 downto 0);
          FROM_BR_PRED: in  STD_LOGIC_VECTOR (9 downto 0);
          BR_LD       : in  STD_LOGIC;
          
          PC_COUNT    : out STD_LOGIC_VECTOR (9 downto 0);
          INSTRUCTION : out std_logic_vector(17 downto 0));
     
   end component;
   
   component stage2 is
       Port (CLK     : in  STD_LOGIC;
         INT_IN       : in STD_LOGIC;
         RESET        : in  STD_LOGIC;
         IN_PORT      : in STD_LOGIC_VECTOR(7 downto 0);
         INSTRUCTION  : in  STD_LOGIC_VECTOR(17 downto 0);
         C_FLAG       : in STD_LOGIC;
         Z_FLAG       : in STD_LOGIC;
         ALU_RES      : in   STD_LOGIC_VECTOR (7 downto 0);
         SCR_OUT      : in   STD_LOGIC_VECTOR (7 downto 0);
         SP_OUT       : in   STD_LOGIC_VECTOR (7 downto 0);
         --RF_D_IN_WR   : in   STD_LOGIC_VECTOR (7 downto 0);
         RF_D_IN_ADR  : in STD_LOGIC_VECTOR (4 downto 0);
         RF_WR        : in   STD_LOGIC;
         RF_WR_SEL    : in   STD_LOGIC_VECTOR (1 downto 0);
         BR_TAKE_CU       : in   STD_LOGIC;
         BR_NOP_CU        : in   STD_LOGIC;
         DATA_NOP         : in   STD_LOGIC;
         
         RF_WR_OUT    : out  STD_LOGIC;
         RF_WR_SEL_OUT: out  STD_LOGIC_VECTOR (1 downto 0);
--         PC_INC       : out  STD_LOGIC;
         PC_LD        : out  STD_LOGIC;
         PC_MUX_SEL   : out  STD_LOGIC_VECTOR (1 downto 0);
         ALU_OPY_SEL  : out  STD_LOGIC;
         ALU_SEL      : out  STD_LOGIC_VECTOR (3 downto 0);
         SP_LD        : out  STD_LOGIC;
         SP_INCR      : out  STD_LOGIC;
         SP_DECR      : out  STD_LOGIC;
         FLG_C_SET    : out  STD_LOGIC;
         FLG_C_CLR    : out  STD_LOGIC;
         FLG_C_LD     : out  STD_LOGIC;
         FLG_Z_LD     : out  STD_LOGIC;
         FLG_LD_SEL   : out  STD_LOGIC;
         FLG_SHAD_LD  : out  STD_LOGIC;
         SCR_WE       : out  STD_LOGIC;
         SCR_ADDR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
         SCR_DATA_SEL : out STD_LOGIC;
         RST          : out STD_LOGIC;
         DX_OUT       : out STD_LOGIC_VECTOR (7 downto 0);
         DY_OUT       : out STD_LOGIC_VECTOR (7 downto 0);
         --RF_D_IN      : out STD_LOGIC_VECTOR (7 downto 0);
         --RF_D_ADR     : out STD_LOGIC_VECTOR (4 downto 0);
         IO_STRB      : out STD_LOGIC;
         PORT_ID      : out STD_LOGIC_VECTOR (7 downto 0));
   end component;
   
   component stage34 is
        Port (CLK     : in  STD_LOGIC;
         INSTRUCTION  : in  STD_LOGIC_VECTOR(12 downto 0);
         ALU_SEL      : in STD_LOGIC_VECTOR(3 downto 0);
         ALU_OPY_SEL  : in STD_LOGIC;
         RST          : in STD_LOGIC;
         SP_LD        : in STD_LOGIC;
         SP_INCR      : in STD_LOGIC;
         SP_DECR      : in STD_LOGIC;
         DX_OUT       : in STD_LOGIC_VECTOR (7 downto 0);
         DY_OUT       : in STD_LOGIC_VECTOR (7 downto 0);
         PC_COUNT     : in STD_LOGIC_VECTOR (9 downto 0);
         SCR_DATA_SEL : in STD_LOGIC;
         SCR_WE       : in STD_LOGIC;
         SCR_ADDR_SEL : in STD_LOGIC_VECTOR (1 downto 0);
         FLG_C_SET    : in STD_LOGIC;
         FLG_C_CLR    : in STD_LOGIC;
         FLG_C_LD     : in STD_LOGIC;
         FLG_Z_LD     : in STD_LOGIC;
         FLG_LD_SEL   : in STD_LOGIC;
         FLG_SHAD_LD  : in STD_LOGIC;
         C_FLAG_IN    : in STD_LOGIC;
         C_FLAG       : out STD_LOGIC;
         Z_FLAG       : out STD_LOGIC;
         C_FLAG_ALU   : out STD_LOGIC;
         Z_FLAG_ALU   : out STD_LOGIC;
         ALU_RES      : out STD_LOGIC_VECTOR (7 downto 0);
         FROM_IMMED   : out STD_LOGIC_VECTOR (9 downto 0);
         FROM_STACK   : out STD_LOGIC_VECTOR (9 downto 0);
         SP_OUT       : out STD_LOGIC_VECTOR (7 downto 0));
   end component;

   component buffer1 is
        Port (CLK         : in  STD_LOGIC;
            B1_EN       : in STD_LOGIC;
            PC_CNT_IN   : in STD_LOGIC_VECTOR(9 downto 0);
            PC_CNT_OUT  : out STD_LOGIC_VECTOR(9 downto 0));
   end component;
   
   component buffer2 is
       Port (CLK         : in STD_LOGIC;
           IR_IN       : in STD_LOGIC_VECTOR(17 downto 0);
           PC_CNT_IN   : in STD_LOGIC_VECTOR(9 downto 0);
           PC_LD_IN    : in STD_LOGIC;
           PC_MUX_SEL_IN : in STD_LOGIC_VECTOR(1 downto 0);
           REG_DX_IN   : in STD_LOGIC_VECTOR(7 downto 0);
           REG_DY_IN   : in STD_LOGIC_VECTOR(7 downto 0);
           RF_WR_IN    : in STD_LOGIC;
           RF_WR_SEL_IN: in STD_LOGIC_VECTOR(1 downto 0);
           ALU_OP_SEL_IN:in STD_LOGIC;
           ALU_SEL_IN  : in STD_LOGIC_VECTOR(3 downto 0);
           SP_LD_IN    : in STD_LOGIC;
           SP_INCR_IN  : in STD_LOGIC;
           SP_DECR_IN  : in STD_LOGIC;
           SCR_WE_IN   : in STD_LOGIC;
           SCR_ADDR_SEL_IN : in STD_LOGIC_VECTOR(1 downto 0);
           SCR_DATA_SEL_IN : in STD_LOGIC;
           FLG_C_SET_IN    : in STD_LOGIC;
           FLG_C_CLR_IN    : in STD_LOGIC;
           FLG_C_LD_IN     : in STD_LOGIC;
           FLG_Z_LD_IN     : in STD_LOGIC;
           FLG_LD_SEL_IN   : in STD_LOGIC;
           FLG_SHAD_LD_IN  : in STD_LOGIC;
           RST_IN          : in STD_LOGIC; 
           BR_NOP          : in STD_LOGIC;
           
           IR_OUT      : out STD_LOGIC_VECTOR(17 downto 0); 
           PC_CNT_OUT  : out STD_LOGIC_VECTOR(9 downto 0);
           PC_LD_OUT   : out STD_LOGIC;
           PC_MUX_SEL_OUT : out STD_LOGIC_VECTOR(1 downto 0);
           REG_DX_OUT  : out STD_LOGIC_VECTOR(7 downto 0);
           REG_DY_OUT  : out STD_LOGIC_VECTOR(7 downto 0);
           RF_WR_OUT    : out STD_LOGIC;
           RF_WR_SEL_OUT: out STD_LOGIC_VECTOR(1 downto 0);
           ALU_OP_SEL_OUT:out STD_LOGIC;
           ALU_SEL_OUT  : out STD_LOGIC_VECTOR(3 downto 0);
           SP_LD_OUT    : out STD_LOGIC;
           SP_INCR_OUT  : out STD_LOGIC;
           SP_DECR_OUT  : out STD_LOGIC;
           SCR_WE_OUT   : out STD_LOGIC;
           SCR_ADDR_SEL_OUT : out STD_LOGIC_VECTOR(1 downto 0);
           SCR_DATA_SEL_OUT : out STD_LOGIC;
           FLG_C_SET_OUT    : out STD_LOGIC;
           FLG_C_CLR_OUT   : out STD_LOGIC;
           FLG_C_LD_OUT     : out STD_LOGIC;
           FLG_Z_LD_OUT     : out STD_LOGIC;
           FLG_LD_SEL_OUT   : out STD_LOGIC;
           FLG_SHAD_LD_OUT  : out STD_LOGIC;
           RST_OUT          : out STD_LOGIC);
   end component;
   
   component buffer3 is
      Port (CLK             : in STD_LOGIC;
--         RF_WR_IN        : in STD_LOGIC;
--         RF_WR_SEL_IN    : in STD_LOGIC_VECTOR(1 downto 0);
--         ALU_RES_IN      : in STD_LOGIC_VECTOR(7 downto 0);
--         SCR_DATA_IN     : in STD_LOGIC_VECTOR(9 downto 0);
--         SP_DATA_IN      : in STD_LOGIC_VECTOR(7 downto 0);
         IR_IN           : in STD_LOGIC_VECTOR(4 downto 0);
         C_FLAG_IN       : in STD_LOGIC;
         Z_FLAG_IN       : in STD_LOGIC;
         
--         RF_WR_OUT       : out STD_LOGIC;
--         RF_WR_SEL_OUT   : out STD_LOGIC_VECTOR(1 downto 0);
--         ALU_RES_OUT     : out STD_LOGIC_VECTOR(7 downto 0);
--         SCR_DATA_OUT    : out STD_LOGIC_VECTOR(9 downto 0);
--         SP_DATA_OUT     : out STD_LOGIC_VECTOR(7 downto 0);
         IR_OUT          : out STD_LOGIC_VECTOR(4 downto 0);
         C_FLAG_OUT      : out STD_LOGIC;
         Z_FLAG_OUT      : out STD_LOGIC);
   end component;

    component hazard_unit is
      Port (CLK             : in STD_LOGIC;
          INSTR           : in STD_LOGIC_VECTOR(17 downto 0);
          PREV_INSTR      : in STD_LOGIC_VECTOR(17 downto 0);
          PC_LD           : in STD_LOGIC;
  
          PC_CLK          : out STD_LOGIC;
          PC_CLK_2        : out STD_LOGIC;
          B1_CLK          : out STD_LOGIC;
          PREV_INSTR_OUT  : out STD_LOGIC_VECTOR(17 downto 0);
          INSTR_OUT       : out STD_LOGIC_VECTOR(17 downto 0);
          DATA_NOP        : out STD_LOGIC);
    end component;
    
    component branch_pred is
      Port ( CLK            : in  STD_LOGIC;
            OPCODE_HI_5     : in  STD_LOGIC_VECTOR (4 downto 0);
            OPCODE_LO_2     : in  STD_LOGIC_VECTOR (1 downto 0);
            PREV_OP_CODE    : in  STD_LOGIC_VECTOR (6 downto 0);
            PC_CNT_T        : in  STD_LOGIC_VECTOR (9 downto 0);
            PC_CNT_NT       : in  STD_LOGIC_VECTOR (9 downto 0);
            C               : in  STD_LOGIC;
            Z               : in  STD_LOGIC;
            DATA_NOP        : in  STD_LOGIC;
            DATA_PC_EN      : in  STD_LOGIC;
            PC_CNT_OUT      : out STD_LOGIC_VECTOR(9 downto 0);
            BR_PC_LD        : out STD_LOGIC;
            BR_NOP_CU       : out STD_LOGIC;
            INSTR_NULL      : out STD_LOGIC;
            INSTR_NULL2     : out STD_LOGIC
            );
            
    end component;

-----------------------------------------------------------------
-- PC signals
-----------------------------------------------------------------
--signal PC_INC_sig : STD_LOGIC;   
signal PC_LD_sig : STD_LOGIC;   
signal PC_MUX_sel_sig : STD_LOGIC_VECTOR(1 downto 0);
signal PC_COUNT_sig : STD_LOGIC_VECTOR(9 downto 0);   
signal s_instr         : STD_LOGIC_VECTOR(17 downto 0);
signal INSTRUCTION_sig : STD_LOGIC_VECTOR(17 downto 0); 

signal FROM_IMMED_sig : STD_LOGIC_VECTOR(9 downto 0);   
signal FROM_STACK_sig : STD_LOGIC_VECTOR(9 downto 0);  
-----------------------------------------------------------------



-----------------------------------------------------------------
-- ALU signals
-----------------------------------------------------------------
signal ALU_OPY_SEL_sig : STD_LOGIC;
signal ALU_SEL_sig : STD_LOGIC_VECTOR(3 downto 0);
-----------------------------------------------------------------



-----------------------------------------------------------------
-- SP signals
-----------------------------------------------------------------
signal SP_LD_sig : STD_LOGIC;
signal SP_INCR_sig : STD_LOGIC;
signal SP_DECR_sig : STD_LOGIC;
-----------------------------------------------------------------



-----------------------------------------------------------------
-- Flag signals
-----------------------------------------------------------------
signal C_FLAG_sig : STD_LOGIC;
signal C_FLAG_IN_sig : STD_LOGIC;
signal C_FLAG_alu_sig : STD_LOGIC;

signal FLG_C_SET_sig : STD_LOGIC;
signal FLG_C_CLR_sig : STD_LOGIC;
signal FLG_C_LD_sig : STD_LOGIC;

signal Z_FLAG_sig : STD_LOGIC;
signal FLG_Z_LD_sig : STD_LOGIC;
signal Z_FLAG_alu_sig : STD_LOGIC;

signal FLG_LD_SEL_sig : STD_LOGIC;
signal FLG_SHAD_LD_sig : STD_LOGIC;
-----------------------------------------------------------------



-----------------------------------------------------------------
-- Scratch ram signals
-----------------------------------------------------------------
signal SCR_WE_sig : STD_LOGIC;
signal SCR_DATA_SEL_sig : STD_LOGIC;
signal SCR_ADDR_SEL_sig : STD_LOGIC_VECTOR(1 downto 0);
-----------------------------------------------------------------



-----------------------------------------------------------------
-- Register file signals
-----------------------------------------------------------------
signal DX_OUT_sig : STD_LOGIC_VECTOR(7 downto 0);
signal DY_OUT_sig : STD_LOGIC_VECTOR(7 downto 0);
signal RF_D_IN_WR_sig : STD_LOGIC_VECTOR(7 downto 0);
signal RF_D_IN_sig : STD_LOGIC_VECTOR(7 downto 0);

signal ALU_RES_sig : STD_LOGIC_VECTOR(7 downto 0);
signal SCR_OUT_sig : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');  
signal SP_OUT_sig : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

signal RF_WR_sig : STD_LOGIC;
signal RF_WR_SEL_sig : STD_LOGIC_VECTOR(1 downto 0);
signal RF_WR_OUT_sig : STD_LOGIC;
signal RF_WR_SEL_OUT_sig : STD_LOGIC_VECTOR(1 downto 0);

signal RF_D_IN_ADR_sig  : STD_LOGIC_VECTOR (4 downto 0);
signal RF_D_ADR_sig  : STD_LOGIC_VECTOR (4 downto 0);
-----------------------------------------------------------------



signal s_rst : STD_LOGIC;




-----------------------------------------------------------------
-- Buffering signals
-----------------------------------------------------------------
--buffer1 signals
   signal s_buff1_pc_count : std_logic_vector(9 downto 0)  := (others => '0'); 
   --buffer2 signals
   signal s_buff2_inst_reg : std_logic_vector(17 downto 0) := (others => '0'); 
   signal s_buff2_pc_count : std_logic_vector(9 downto 0)  := (others => '0');
   signal s_buff2_pc_ld    : std_logic := '0';
   signal s_buff2_pc_mux_sel : std_logic_vector(1 downto 0) := (others => '0');
   signal s_buff2_rf_wr_sel : STD_LOGIC_VECTOR(1 downto 0) := "00";
   signal s_buff2_rf_wr     : STD_LOGIC := '0';
   signal s_buff2_reg_in    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   signal s_buff2_reg_x_out : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   signal s_buff2_reg_y_out : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   signal s_buff2_flg_c_set   : STD_LOGIC;
   signal s_buff2_flg_c_clr   : STD_LOGIC;
   signal s_buff2_flg_c_ld    : STD_LOGIC;
   signal s_buff2_flg_z_ld    : STD_LOGIC;
   signal s_buff2_flg_ld_sel  : STD_LOGIC;
   signal s_buff2_flg_shad_ld : STD_LOGIC;
   signal s_buff2_alu_opy_sel : STD_LOGIC;
   signal s_buff2_alu_sel     : STD_LOGIC_VECTOR(3 downto 0);
   signal s_buff2_sp_ld     : STD_LOGIC;
   signal s_buff2_sp_incr   : STD_LOGIC;
   signal s_buff2_sp_decr   : STD_LOGIC;
   signal s_buff2_scr_we       : STD_LOGIC;
   signal s_buff2_scr_addr_sel : STD_LOGIC_VECTOR(1 downto 0);
   signal s_buff2_scr_data_sel : STD_LOGIC;
   signal s_buff2_rst : STD_LOGIC;
   
   --buffer3 signals
   signal s_buff3_inst_reg : std_logic_vector(4 downto 0) := (others => '0'); 
   signal s_buff3_rf_wr_sel : STD_LOGIC_VECTOR(1 downto 0) := "00";
   signal s_buff3_rf_wr     : STD_LOGIC := '0';
   signal s_buff3_alu_res     : STD_LOGIC_VECTOR(7 downto 0);
   signal s_buff3_scr_out      : STD_LOGIC_VECTOR(9 downto 0);
   signal s_buff3_sp_out    : STD_LOGIC_VECTOR(7 downto 0);
   signal s_buff3_c_flg     : STD_LOGIC := '0';
   signal s_buff3_z_flg     : STD_LOGIC := '0';
   
   --hazard signals
   signal s_prev_instr  : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
   signal s_pc_clk  : STD_LOGIC := '1';
   signal s_pc_clk_2 : STD_LOGIC := '1';
   signal s_b1_clk  : STD_LOGIC := '1';
   signal s_instr_hzd : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
   signal s_data_nop   : STD_LOGIC := '0';
   
   
   --branch predictor signals
   signal s_br_alt      : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
   signal s_br_ld       : STD_LOGIC;
   signal s_br_nop_cu   : STD_LOGIC;
   signal s_br_prev_op  : STD_LOGIC_VECTOR (6 downto 0) := (others => '0');
   signal s_instr_null  : STD_LOGIC := '0';
   signal s_instr_null2 : STD_LOGIC := '0';
   
-----------------------------------------------------------------




begin

fetch : stage1
    Port Map(
        CLK             => CLK,
        S1_EN           => s_pc_clk,
        S1_EN_2         => s_pc_clk_2,
--        PC_INC          => PC_INC_sig,
        PC_LD           => s_buff2_pc_ld,
        RST             => s_rst,
        PC_MUX_SEL      => s_buff2_pc_mux_sel,--PC_MUX_SEL_sig,
        FROM_IMMED      => FROM_IMMED_sig,
        FROM_STACK      => FROM_STACK_sig,
        FROM_BR_PRED    => s_br_alt,
        BR_LD           => s_br_ld,
        PC_COUNT        => PC_COUNT_sig,
        INSTRUCTION     => s_instr);

fetch_buffer : buffer1
    Port Map(
        CLK        => CLK,
        B1_EN      => s_b1_clk,
        PC_CNT_IN   => PC_COUNT_sig,
        PC_CNT_OUT  => s_buff1_pc_count);

decode : stage2
    Port Map(
        CLK             => CLK,
        INT_IN          => INT_IN,
        RESET           => RST,
        IN_PORT         => IN_PORT,
        INSTRUCTION     => s_instr_hzd,
        C_FLAG          => C_FLAG_alu_sig, --s_buff3_c_flg,
        Z_FLAG          => Z_FLAG_alu_sig, --s_buff3_z_flg,
        ALU_RES         => ALU_RES_sig,
        SCR_OUT         => FROM_STACK_sig(7 downto 0),
        SP_OUT          => SP_OUT_sig,
        --RF_D_IN_WR      => RF_D_IN_WR_sig,
        RF_D_IN_ADR     => s_buff2_inst_reg(12 downto 8),
        RF_WR           => s_buff2_rf_wr,
        RF_WR_SEL       => s_buff2_rf_wr_sel,
        BR_TAKE_CU      =>  s_br_ld,
        BR_NOP_CU       =>  s_br_nop_cu,     
        DATA_NOP        => s_data_nop,  
        
        RF_WR_OUT       => RF_WR_OUT_sig,
        RF_WR_SEL_OUT   => RF_WR_SEL_OUT_sig,
--        PC_INC          => PC_INC_sig,
        PC_LD           => PC_LD_sig,
        PC_MUX_SEL      => PC_MUX_SEL_sig,
        ALU_OPY_SEL     => ALU_OPY_SEL_sig,
        ALU_SEL         => ALU_SEL_sig,
        SP_LD           => SP_LD_sig,
        SP_INCR         => SP_INCR_sig,
        SP_DECR         => SP_DECR_sig,
        FLG_C_SET       => FLG_C_SET_sig,
        FLG_C_CLR       => FLG_C_CLR_sig,
        FLG_C_LD        => FLG_C_LD_sig,
        FLG_Z_LD        => FLG_Z_LD_sig,
        FLG_LD_SEL      => FLG_LD_SEL_sig,
        FLG_SHAD_LD     => FLG_SHAD_LD_sig,
        SCR_WE          => SCR_WE_sig,
        SCR_ADDR_SEL    => SCR_ADDR_SEL_sig,
        SCR_DATA_SEL    => SCR_DATA_SEL_sig,
        RST             => s_rst,
        DX_OUT          => DX_OUT_sig,
        DY_OUT          => DY_OUT_sig,
        --RF_D_IN         => RF_D_IN_sig,
        --RF_D_ADR        => RF_D_ADR_sig,
        IO_STRB         => IO_STRB,
        PORT_ID         => PORT_ID);
 
decode_buffer : buffer2
    Port Map(
        CLK             => CLK,
        IR_IN           => s_instr_hzd(17 downto 0),
        PC_CNT_IN       => s_buff1_pc_count,
        PC_LD_IN        => PC_LD_sig,
        PC_MUX_SEL_IN   => PC_MUX_SEL_sig,
        REG_DX_IN       => DX_OUT_sig,
        REG_DY_IN       => DY_OUT_sig,
        RF_WR_IN        => RF_WR_OUT_sig,
        RF_WR_SEL_IN    => RF_WR_SEL_OUT_sig,
        ALU_OP_SEL_IN   => ALU_OPY_SEL_sig,
        ALU_SEL_IN      => ALU_SEL_sig,
        SP_LD_IN        => SP_LD_sig,
        SP_INCR_IN      => SP_INCR_sig,
        SP_DECR_IN      => SP_DECR_sig,
        SCR_WE_IN       => SCR_WE_sig,
        SCR_ADDR_SEL_IN => SCR_ADDR_SEL_sig,
        SCR_DATA_SEL_IN => SCR_DATA_SEL_sig,
        FLG_C_SET_IN    => FLG_C_SET_sig,
        FLG_C_CLR_IN    => FLG_C_CLR_sig,
        FLG_C_LD_IN     => FLG_C_LD_sig,
        FLG_Z_LD_IN     => FLG_Z_LD_sig,
        FLG_LD_SEL_IN   => FLG_LD_SEL_sig,
        FLG_SHAD_LD_IN  => FLG_SHAD_LD_sig,
        RST_IN          => RST,
        BR_NOP          => s_br_nop_cu,
              
        IR_OUT      => s_buff2_inst_reg, 
        PC_CNT_OUT  => s_buff2_pc_count,
        PC_LD_OUT   => s_buff2_pc_ld,
        PC_MUX_SEL_OUT => s_buff2_pc_mux_sel, 
        REG_DX_OUT  => s_buff2_reg_x_out,
        REG_DY_OUT  => s_buff2_reg_y_out,
        RF_WR_OUT   => s_buff2_rf_wr,
        RF_WR_SEL_OUT => s_buff2_rf_wr_sel,
        ALU_OP_SEL_OUT => s_buff2_alu_opy_sel,
        ALU_SEL_OUT    => s_buff2_alu_sel,
        SP_LD_OUT      => s_buff2_sp_ld ,
        SP_INCR_OUT    => s_buff2_sp_incr,
        SP_DECR_OUT    => s_buff2_sp_decr,
        SCR_WE_OUT     => s_buff2_scr_we,
        SCR_ADDR_SEL_OUT => s_buff2_scr_addr_sel,
        SCR_DATA_SEL_OUT => s_buff2_scr_data_sel,
        FLG_C_SET_OUT  => s_buff2_flg_c_set,
        FLG_C_CLR_OUT  => s_buff2_flg_c_clr,
        FLG_C_LD_OUT   => s_buff2_flg_c_ld,
        FLG_Z_LD_OUT   => s_buff2_flg_z_ld,
        FLG_LD_SEL_OUT => s_buff2_flg_ld_sel,
        FLG_SHAD_LD_OUT => s_buff2_flg_shad_ld,
        RST_OUT        => s_buff2_rst);
 
exwr : stage34
    Port Map(CLK      => CLK,
        INSTRUCTION   => s_buff2_inst_reg(12 downto 0),
        ALU_SEL       => s_buff2_alu_sel,
        ALU_OPY_SEL   => s_buff2_alu_opy_sel,
        RST           => s_buff2_rst,
        SP_LD         => s_buff2_sp_ld ,
        SP_INCR       => s_buff2_sp_incr,
        SP_DECR       => s_buff2_sp_decr,
        DX_OUT        => s_buff2_reg_x_out,
        DY_OUT        => s_buff2_reg_y_out,
        PC_COUNT      => s_buff2_pc_count,
        SCR_DATA_SEL  => s_buff2_scr_data_sel,
        SCR_WE        => s_buff2_scr_we,
        SCR_ADDR_SEL  => s_buff2_scr_addr_sel,
        FLG_C_SET     => s_buff2_flg_c_set,
        FLG_C_CLR     => s_buff2_flg_c_clr,
        FLG_C_LD      => s_buff2_flg_c_ld,
        FLG_Z_LD      => s_buff2_flg_z_ld,
        FLG_LD_SEL    => s_buff2_flg_ld_sel,
        FLG_SHAD_LD   => s_buff2_flg_shad_ld,
        C_FLAG_IN     => s_buff3_c_flg,
        C_FLAG        => C_FLAG_sig,
        Z_FLAG        => Z_FLAG_sig,
        C_FLAG_ALU    => C_FLAG_alu_sig,
        Z_FLAG_ALU    => Z_FLAG_alu_sig,
        ALU_RES       => ALU_RES_sig,
        FROM_IMMED    => FROM_IMMED_sig,
        FROM_STACK    => FROM_STACK_sig,
        SP_OUT        => SP_OUT_sig);
        
exec_buffer : buffer3
    Port Map(
        CLK          => CLK,   
--        RF_WR_IN        => s_buff2_rf_wr,
--        RF_WR_SEL_IN    => s_buff2_rf_wr_sel,
--        ALU_RES_IN      => ALU_RES_sig,
--        SCR_DATA_IN     => FROM_STACK_sig,
--        SP_DATA_IN      => SP_OUT_sig,
        IR_IN           => s_buff2_inst_reg(12 downto 8),
        C_FLAG_IN       => C_FLAG_sig,
        Z_FLAG_IN       => Z_FLAG_sig,
        
--        RF_WR_OUT       => s_buff3_rf_wr,
--        RF_WR_SEL_OUT   => s_buff3_rf_wr_sel,
--        ALU_RES_OUT     => s_buff3_alu_res,
--        SCR_DATA_OUT    => s_buff3_scr_out,
--        SP_DATA_OUT     => s_buff3_sp_out,
        IR_OUT          => s_buff3_inst_reg,
        C_FLAG_OUT      => s_buff3_c_flg,
        Z_FLAG_OUT      => s_buff3_z_flg);

hazard : hazard_unit
    Port Map (CLK       => CLK,
        INSTR           => INSTRUCTION_sig,
        PREV_INSTR      => s_prev_instr,
        PC_LD           => PC_LD_sig,
    
        PC_CLK          => s_pc_clk,
        PC_CLK_2        => s_pc_clk_2,
        B1_CLK          => s_b1_clk,
        PREV_INSTR_OUT  => s_prev_instr,
        INSTR_OUT       => s_instr_hzd, 
        DATA_NOP        => s_data_nop);

br_pred : branch_pred
    Port Map (CLK           => CLK, 
            OPCODE_HI_5     => INSTRUCTION_sig(17 downto 13), 
            OPCODE_LO_2     => INSTRUCTION_sig(1 downto 0), 
            PREV_OP_CODE    => s_br_prev_op, 
            PC_CNT_T        => INSTRUCTION_sig(12 downto 3), 
            PC_CNT_NT       => PC_COUNT_sig, 
            C               => C_FLAG_alu_sig,
            Z               => Z_FLAG_alu_sig,
            DATA_NOP        => s_data_nop,
            DATA_PC_EN      => s_pc_clk, 
            PC_CNT_OUT      => s_br_alt, 
            BR_PC_LD        => s_br_ld, 
            BR_NOP_CU       => s_br_nop_cu,
            INSTR_NULL      => s_instr_null,
            INSTR_NULL2     => s_instr_null2
            );

    INSTRUCTION_sig <= s_instr when (s_instr_null = '0' and s_instr_null2 = '0') else
                        (others => '1');
                        

    
   -- RF_D_IN_WR_sig <= RF_D_IN_sig;
   -- RF_D_IN_ADR_sig <= RF_D_ADR_sig;
    RF_WR_sig <= RF_WR_OUT_sig;
    RF_WR_SEL_sig <= RF_WR_SEL_OUT_sig;
    
    SCR_OUT_sig <= FROM_STACK_sig;
    C_FLAG_IN_sig <= C_FLAG_sig;
    s_br_prev_op  <=  s_instr_hzd(17 downto 13) & s_instr_hzd(1 downto 0);

    
    OUT_PORT <= DX_OUT_sig(7 downto 0);

end Behavioral;
