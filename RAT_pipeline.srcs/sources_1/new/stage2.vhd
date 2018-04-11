----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2018 04:00:27 PM
-- Design Name: 
-- Module Name: stage2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity stage2 is
    Port ( CLK     : in  STD_LOGIC;
      INT_IN       : in STD_LOGIC;
      RESET        : in  STD_LOGIC;
      IN_PORT      : in STD_LOGIC_VECTOR(7 downto 0);
      INSTRUCTION  : in  STD_LOGIC_VECTOR(17 downto 0);
      C_FLAG       : in STD_LOGIC;
      Z_FLAG       : in STD_LOGIC;
      PC_INC       : out  STD_LOGIC;
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
      IO_STRB      : out STD_LOGIC;

      OUT_PORT     : out STD_LOGIC_VECTOR (7 downto 0));
end stage2;


architecture Behavioral of stage2 is
signal PC_COUNT_sig : STD_LOGIC_VECTOR(9 downto 0);


component CONTROL_UNIT
   Port ( CLK           : in   STD_LOGIC;
          C             : in   STD_LOGIC;
          Z             : in   STD_LOGIC;
          INT           : in   STD_LOGIC;
          RESET         : in   STD_LOGIC;
          OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
          OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
          
          PC_LD         : out  STD_LOGIC;
          PC_INC        : out  STD_LOGIC;		  
          PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);
          
          SP_LD         : out  STD_LOGIC;
          SP_INCR       : out  STD_LOGIC;
          SP_DECR       : out  STD_LOGIC;
          
          RF_WR         : out  STD_LOGIC;
          RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);
          
          ALU_OPY_SEL   : out  STD_LOGIC;
          ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);
          
          SCR_WE        : out  STD_LOGIC;
          SCR_DATA_SEL  : out  STD_LOGIC;
          SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
          
          FLG_C_SET     : out  STD_LOGIC;
          FLG_C_CLR     : out  STD_LOGIC;
          FLG_C_LD      : out  STD_LOGIC;
          FLG_Z_LD      : out  STD_LOGIC;
          FLG_LD_SEL    : out  STD_LOGIC;
          FLG_SHAD_LD   : out  STD_LOGIC;
          
          I_SET         : out  STD_LOGIC;
          I_CLR         : out  STD_LOGIC;
          IO_STRB       : out  STD_LOGIC;
          
          RST           : out  STD_LOGIC);
end component;

component RegisterFile 
   Port ( D_IN   : in     STD_LOGIC_VECTOR (7 downto 0);
          DX_OUT : out  STD_LOGIC_VECTOR (7 downto 0);
          DY_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
          ADRX   : in     STD_LOGIC_VECTOR (4 downto 0);
          ADRY   : in     STD_LOGIC_VECTOR (4 downto 0);
          WE     : in     STD_LOGIC;
          CLK    : in     STD_LOGIC);
end component;


   -- intermediate signals ----------------------------------
    
   signal s_rf_wr_sel : STD_LOGIC_VECTOR(1 downto 0) := "00";
   signal s_rf_wr     : STD_LOGIC := '0';
   signal s_reg_in    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');



   -- Interrupts
   signal s_flg_i_set  : STD_LOGIC;
   signal s_flg_i_clr  : STD_LOGIC; 

   -- helpful aliases ------------------------------------------------------------------
   alias s_ir_immed_bits : std_logic_vector(9 downto 0) is INSTRUCTION(12 downto 3); 
   
   

begin


   my_cu: CONTROL_UNIT 
   port map ( CLK           => CLK, 
              C             => C_FLAG,
              Z             => Z_FLAG,
              INT           => INT_IN, 
              RESET         => RESET, 
              OPCODE_HI_5   => INSTRUCTION(17 downto 13), 
              OPCODE_LO_2   => INSTRUCTION(1  downto  0), 
              
              PC_LD         => PC_LD, 
              PC_INC        => PC_INC, 
              PC_MUX_SEL    => PC_MUX_SEL, 
              
              SP_LD         => SP_LD, 
              SP_INCR       => SP_INCR, 
              SP_DECR       => SP_DECR, 
              
              RF_WR         => s_rf_wr, 
              RF_WR_SEL     => s_rf_wr_sel, 
              
              ALU_OPY_SEL   => ALU_OPY_SEL, 
              ALU_SEL       => ALU_SEL, 
              
              SCR_WE        => SCR_WE, 
              SCR_ADDR_SEL  => SCR_ADDR_SEL, 
              SCR_DATA_SEL  => SCR_DATA_SEL,
              
              FLG_C_SET    => FLG_C_SET, 
              FLG_C_CLR    => FLG_C_CLR, 
              FLG_C_LD     => FLG_C_LD, 
              FLG_Z_LD     => FLG_Z_LD, 
              FLG_LD_SEL   => FLG_LD_SEL, 
              FLG_SHAD_LD  => FLG_SHAD_LD, 
 
              I_SET        => s_flg_i_set, 
              I_CLR        => s_flg_i_clr, 
              IO_STRB      => IO_STRB,
              
              RST          => RST);
              
   my_regfile: RegisterFile 
   port map ( D_IN   => s_reg_in,   
              DX_OUT => DX_OUT,   
              DY_OUT => DY_OUT,   
              ADRX   => INSTRUCTION(12 downto 8),   
              ADRY   => INSTRUCTION(7  downto 3),    
              WE     => s_rf_wr,  
              CLK    => CLK); 

    
    with s_rf_wr_sel select
          s_reg_in <= s_alu_res             when "00",
                      s_scr_out(7 downto 0) when "01",
                      s_sp_out              when "10",
                      IN_PORT               when "11",
                      x"00" when others;
               
    PORT_ID <= INSTRUCTION(7 downto 0);
    s_int <= s_i_flg AND INT_IN;
    OUT_PORT <= DX_OUT;
    

end Behavioral;