----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2018 04:00:27 PM
-- Design Name: 
-- Module Name: stage34 - Behavioral
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

entity stage34 is
    Port ( CLK     : in  STD_LOGIC;
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
      ALU_RES      : out STD_LOGIC_VECTOR (7 downto 0);
      FROM_IMMED   : out STD_LOGIC_VECTOR (9 downto 0);
      FROM_STACK   : out STD_LOGIC_VECTOR (9 downto 0);
      SP_OUT       : out STD_LOGIC_VECTOR (7 downto 0));
end stage34;


architecture Behavioral of stage34 is
signal PC_COUNT_sig : STD_LOGIC_VECTOR(9 downto 0);

component ALU
   Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
          B : in  STD_LOGIC_VECTOR (7 downto 0);
          Cin : in  STD_LOGIC;
          SEL : in  STD_LOGIC_VECTOR(3 downto 0);
          C : out  STD_LOGIC;
          Z : out  STD_LOGIC;
          RESULT : out  STD_LOGIC_VECTOR (7 downto 0));
end component;


component Flags
  Port (  CLK         : in STD_LOGIC;
          FLG_C_SET   : in STD_LOGIC;
          FLG_C_CLR   : in STD_LOGIC;
          FLG_C_LD    : in STD_LOGIC;
          FLG_Z_LD    : in STD_LOGIC;
          FLG_LD_SEL  : in STD_LOGIC;
          FLG_SHAD_LD : in STD_LOGIC;
          C           : in STD_LOGIC;
          Z           : in STD_LOGIC;
          C_FLAG      : out STD_LOGIC;
          Z_FLAG      : out STD_LOGIC);
end component;

component SCRATCH_RAM
   Port ( CLK   : IN  STD_LOGIC;
          WE    : IN  STD_LOGIC;
          ADDR  : IN  STD_LOGIC_VECTOR(7 downto 0);
          DATA_IN  : IN  STD_LOGIC_VECTOR(9 downto 0);
          DATA_OUT : OUT STD_LOGIC_VECTOR(9 downto 0));
end component;

component SP
   Port ( RST : in STD_LOGIC;
          SP_LD : in STD_LOGIC;
          SP_INCR : in STD_LOGIC;
          SP_DECR : in STD_LOGIC;
          DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
          CLK : in STD_LOGIC;
          DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;


   -- intermediate signals ----------------------------------
    
   signal s_rf_wr_sel : STD_LOGIC_VECTOR(1 downto 0) := "00";
   signal s_rf_wr     : STD_LOGIC := '0';
   signal s_reg_in    : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   
   
   -- C & Z Flags
   signal s_c_flg : STD_LOGIC;
   signal s_z_flg : STD_LOGIC;
   
   -- C & Z Controls
   signal s_flg_c_set   : STD_LOGIC;
   signal s_flg_c_clr   : STD_LOGIC;
   signal s_flg_c_ld    : STD_LOGIC;
   signal s_flg_z_ld    : STD_LOGIC;
   signal s_flg_ld_sel  : STD_LOGIC;
   signal s_flg_shad_ld : STD_LOGIC;
   
   -- ALU
   signal s_alu_opy_sel : STD_LOGIC;
   signal s_alu_res     : STD_LOGIC_VECTOR(7 downto 0);
   signal s_alu_sel     : STD_LOGIC_VECTOR(3 downto 0);
   signal s_alu_b       : STD_LOGIC_VECTOR(7 downto 0);
   signal s_c           : STD_LOGIC;
   signal s_z           : STD_LOGIC;

   -- Stack Pointer
   signal s_sp_ld     : STD_LOGIC;
   signal s_sp_incr   : STD_LOGIC;
   signal s_sp_decr   : STD_LOGIC;
   signal s_sp_out    : STD_LOGIC_VECTOR(7 downto 0);

   
   -- Scratch
   signal s_scr_we       : STD_LOGIC;
   signal s_scr_addr     : STD_LOGIC_VECTOR(7 downto 0);
   signal s_scr_addr_sel : STD_LOGIC_VECTOR(1 downto 0);
   signal s_scr_data_sel : STD_LOGIC;
   signal s_scr_in       : STD_LOGIC_VECTOR(9 downto 0);
   signal s_scr_out      : STD_LOGIC_VECTOR(9 downto 0);
   
   -- RESET
   signal s_rst : STD_LOGIC;
   

   -- helpful aliases ------------------------------------------------------------------
   alias s_ir_immed_bits : std_logic_vector(9 downto 0) is INSTRUCTION(12 downto 3);
   
   

begin

   my_alu: ALU
   port map ( A => DX_OUT,       
              B => s_alu_b,       
              Cin => C_FLAG_IN,     
              SEL => ALU_SEL,     
              C => s_c,       
              Z => s_z,       
              RESULT => ALU_RES );

   my_flgs: Flags
   port map ( CLK         => CLK,
              FLG_C_SET   => FLG_C_SET,
              FLG_C_CLR   => FLG_C_CLR,
              FLG_C_LD    => FLG_C_LD,
              FLG_Z_LD    => FLG_Z_LD,
              FLG_LD_SEL  => FLG_LD_SEL,
              FLG_SHAD_LD => FLG_SHAD_LD,
              C           => s_c,
              Z           => s_z,
              C_FLAG      => C_FLAG,
              Z_FLAG      => Z_FLAG);
                         
   my_SCR: SCRATCH_RAM
   port map ( CLK      => CLK,
              WE       => SCR_WE,
              ADDR     => s_scr_addr,
              DATA_IN  => s_scr_in,
              DATA_OUT => s_scr_out);
              
   my_SP: SP
   port map ( RST      => RST,
              SP_LD    => SP_LD,
              SP_INCR  => SP_INCR,
              SP_DECR  => SP_DECR,
              DATA_IN  => DX_OUT,
              CLK      => CLK,
              DATA_OUT => s_sp_out);

    with ALU_OPY_SEL select
        s_alu_b <= DY_OUT when '0',
                   INSTRUCTION(7 downto 0) when '1',
                   x"00" when others;

    
    with SCR_DATA_SEL select
        s_scr_in <= "00" & DX_OUT when '0',
                    PC_COUNT         when '1',
                    "00" & x"00"       when others;
    
    with SCR_ADDR_SEL select
        s_scr_addr <= DY_OUT            when "00",
                      INSTRUCTION(7 downto 0) when "01",
                      s_sp_out               when "10",
                      s_sp_out - 1           when "11",
                      x"00"                  when others;
    
    FROM_STACK <= s_scr_out;
    FROM_IMMED <= s_ir_immed_bits;
    SP_OUT <= s_sp_out;

end Behavioral;
