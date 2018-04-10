----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2018 03:03:02 PM
-- Design Name: 
-- Module Name: pipeline_sec234 - Behavioral
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

entity pipeline_sec234 is
    Port ( CLK     : in  STD_LOGIC;
      INT_IN       : in STD_LOGIC;
      RESET         : in  STD_LOGIC;
      PC_COUNT     : in  STD_LOGIC_VECTOR(9 downto 0);
      IN_PORT      : in STD_LOGIC_VECTOR(7 downto 0);
      INSTRUCTION  : in  STD_LOGIC_VECTOR(17 downto 0);
      PC_INC      : out  STD_LOGIC;
      PC_LD       : out  STD_LOGIC;
      RST         : out STD_LOGIC;
      IO_STRB     : out STD_LOGIC;
      PC_MUX_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
      PORT_ID     : out STD_LOGIC_VECTOR (7 downto 0);
      OUT_PORT    : out STD_LOGIC_VECTOR (7 downto 0);
      FROM_IMMED  : out  STD_LOGIC_VECTOR (9 downto 0);
      FROM_STACK  : out  STD_LOGIC_VECTOR (9 downto 0));
end pipeline_sec234;


architecture Behavioral of pipeline_sec234 is
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

component I_FLAG
  Port (  I_SET : in STD_LOGIC;
          I_CLR : in STD_LOGIC;
          CLK : in STD_LOGIC;
          I_OUT : out STD_LOGIC);
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
   
   -- Register
   signal s_reg_x_out : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   signal s_reg_y_out : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
   
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
   
   -- Interrupts
   signal s_i_flg      : STD_LOGIC;
   signal s_flg_i_set  : STD_LOGIC;
   signal s_flg_i_clr  : STD_LOGIC; 
   signal s_int        : STD_LOGIC;
   
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
   port map ( A => s_reg_x_out,       
              B => s_alu_b,       
              Cin => s_c_flg,     
              SEL => s_alu_sel,     
              C => s_c,       
              Z => s_z,       
              RESULT => s_alu_res ); 


   my_cu: CONTROL_UNIT 
   port map ( CLK           => CLK, 
              C             => s_c_flg, 
              Z             => s_z_flg, 
              INT           => s_int, 
              RESET         => RESET, 
              OPCODE_HI_5   => INSTRUCTION(17 downto 13), 
              OPCODE_LO_2   => INSTRUCTION(1  downto  0), 
              
              PC_LD         => PC_LD, 
              PC_INC        => PC_INC, 
              PC_MUX_SEL    => PC_MUX_SEL, 
              
              SP_LD         => s_sp_ld, 
              SP_INCR       => s_sp_incr, 
              SP_DECR       => s_sp_decr, 
              
              RF_WR         => s_rf_wr, 
              RF_WR_SEL     => s_rf_wr_sel, 
              
              ALU_OPY_SEL   => s_alu_opy_sel, 
              ALU_SEL       => s_alu_sel, 
              
              SCR_WE        => s_scr_we, 
              SCR_ADDR_SEL  => s_scr_addr_sel, 
              SCR_DATA_SEL  => s_scr_data_sel,
              
              FLG_C_SET    => s_flg_c_set, 
              FLG_C_CLR    => s_flg_c_clr, 
              FLG_C_LD     => s_flg_c_ld, 
              FLG_Z_LD     => s_flg_z_ld, 
              FLG_LD_SEL   => s_flg_ld_sel, 
              FLG_SHAD_LD  => s_flg_shad_ld, 
 
              I_SET        => s_flg_i_set, 
              I_CLR        => s_flg_i_clr, 
              IO_STRB      => IO_STRB,
              
              RST          => s_rst);
              
   my_regfile: RegisterFile 
   port map ( D_IN   => s_reg_in,   
              DX_OUT => s_reg_x_out,   
              DY_OUT => s_reg_y_out,   
              ADRX   => INSTRUCTION(12 downto 8),   
              ADRY   => INSTRUCTION(7  downto 3),    
              WE     => s_rf_wr,  
              CLK    => CLK); 

   my_flgs: Flags
   port map ( CLK         => CLK,
              FLG_C_SET   => s_flg_c_set,
              FLG_C_CLR   => s_flg_c_clr,
              FLG_C_LD    => s_flg_c_ld,
              FLG_Z_LD    => s_flg_z_ld,
              FLG_LD_SEL  => s_flg_ld_sel,
              FLG_SHAD_LD => s_flg_shad_ld,
              C           => s_c,
              Z           => s_z,
              C_FLAG      => s_c_flg,
              Z_FLAG      => s_z_flg);
   
   
   my_i_flg: I_FLAG
   port map ( I_SET => s_flg_i_set,
              I_CLR => s_flg_i_clr,
              CLK => CLK,
              I_OUT => s_i_flg);
                         
   my_SCR: SCRATCH_RAM
   port map ( CLK      => CLK,
              WE       => s_scr_we,
              ADDR     => s_scr_addr,
              DATA_IN  => s_scr_in,
              DATA_OUT => s_scr_out);
              
   my_SP: SP
   port map ( RST      => s_rst,
              SP_LD    => s_sp_ld,
              SP_INCR  => s_sp_incr,
              SP_DECR  => s_sp_decr,
              DATA_IN  => s_reg_x_out,
              CLK      => CLK,
              DATA_OUT => s_sp_out);

    with s_alu_opy_sel select
        s_alu_b <= s_reg_y_out when '0',
                   INSTRUCTION(7 downto 0) when '1',
                   x"00" when others;
                   
    with s_rf_wr_sel select
        s_reg_in <= s_alu_res             when "00",
                    s_scr_out(7 downto 0) when "01",
                    s_sp_out              when "10",
                    IN_PORT               when "11",
                    x"00" when others;
    
    with s_scr_data_sel select
        s_scr_in <= "00" & s_reg_x_out when '0',
                    PC_COUNT         when '1',
                    "00" & x"00"       when others;
    
    with s_scr_addr_sel select
        s_scr_addr <= s_reg_y_out            when "00",
                      INSTRUCTION(7 downto 0) when "01",
                      s_sp_out               when "10",
                      s_sp_out - 1           when "11",
                      x"00"                  when others;
                   
    FROM_STACK <= s_scr_out;
    FROM_IMMED <= s_ir_immed_bits;
    OUT_PORT <= s_reg_x_out;
    RST <= s_rst;
    s_int <= s_i_flg AND INT_IN;
    PORT_ID <= INSTRUCTION(7 downto 0);

end Behavioral;
