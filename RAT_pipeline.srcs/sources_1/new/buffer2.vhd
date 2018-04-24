----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2018 06:54:57 PM
-- Design Name: 
-- Module Name: buffer2 - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity buffer2 is
  Port (CLK         : in STD_LOGIC;
        IR_IN       : in STD_LOGIC_VECTOR(12 downto 0);
        PC_CNT_IN   : in STD_LOGIC_VECTOR(9 downto 0);
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
        
        IR_OUT      : out STD_LOGIC_VECTOR(12 downto 0); 
        PC_CNT_OUT  : out STD_LOGIC_VECTOR(9 downto 0);
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
        
end buffer2;

architecture Behavioral of buffer2 is

signal s_IR_IN       : STD_LOGIC_VECTOR(12 downto 0);
signal s_PC_CNT_IN   :  STD_LOGIC_VECTOR(9 downto 0);
signal s_REG_DX_IN   :  STD_LOGIC_VECTOR(7 downto 0);
signal s_REG_DY_IN   :  STD_LOGIC_VECTOR(7 downto 0);
signal s_RF_WR_IN    :  STD_LOGIC;
signal s_RF_WR_SEL_IN:  STD_LOGIC_VECTOR(1 downto 0);
signal s_ALU_OP_SEL_IN: STD_LOGIC;
signal s_ALU_SEL_IN  :  STD_LOGIC_VECTOR(3 downto 0);
signal s_SP_LD_IN    :  STD_LOGIC;
signal s_SP_INCR_IN  :  STD_LOGIC;
signal s_SP_DECR_IN  :  STD_LOGIC;
signal s_SCR_WE_IN   :  STD_LOGIC;
signal s_SCR_ADDR_SEL_IN :  STD_LOGIC_VECTOR(1 downto 0);
signal s_SCR_DATA_SEL_IN :  STD_LOGIC;
signal s_FLG_C_SET_IN    :  STD_LOGIC;
signal s_FLG_C_CLR_IN    :  STD_LOGIC;
signal s_FLG_C_LD_IN     :  STD_LOGIC;
signal s_FLG_Z_LD_IN     :  STD_LOGIC;
signal s_FLG_LD_SEL_IN   :  STD_LOGIC;
signal s_FLG_SHAD_LD_IN  :  STD_LOGIC;
signal s_RST_IN          :  STD_LOGIC;



begin

    latch: process(CLK)
    begin
        if(RISING_EDGE(CLK)) then
            s_IR_IN <= IR_IN;
            s_PC_CNT_IN <= PC_CNT_IN;
            s_REG_DX_IN <= REG_DX_IN;
            s_REG_DY_IN <= REG_DY_IN;
            s_RF_WR_IN <= RF_WR_IN;
            s_RF_WR_SEL_IN <= RF_WR_SEL_IN;
            s_ALU_OP_SEL_IN <= ALU_OP_SEL_IN;
            s_ALU_SEL_IN  <= ALU_SEL_IN;
            s_SP_LD_IN <= SP_LD_IN;
            s_SP_INCR_IN  <= SP_INCR_IN;
            s_SP_DECR_IN <= SP_DECR_IN;
            s_SCR_WE_IN <= SCR_WE_IN;
            s_SCR_ADDR_SEL_IN <= SCR_ADDR_SEL_IN;
            s_SCR_DATA_SEL_IN  <= SCR_DATA_SEL_IN;
            s_FLG_C_SET_IN <= FLG_C_SET_IN;
            s_FLG_C_CLR_IN <= FLG_C_CLR_IN;
            s_FLG_C_LD_IN <= FLG_C_LD_IN;
            s_FLG_Z_LD_IN <= FLG_Z_LD_IN;
            s_FLG_LD_SEL_IN <= FLG_LD_SEL_IN;
            s_FLG_SHAD_LD_IN <= FLG_SHAD_LD_IN;
            s_RST_IN  <= RST_IN;
        end if;
    end process latch;

    IR_OUT <= s_IR_IN;
    PC_CNT_OUT <= s_PC_CNT_IN;
    REG_DX_OUT <= s_REG_DX_IN;
    REG_DY_OUT <= s_REG_DY_IN;
    RF_WR_OUT <= s_RF_WR_IN;
    RF_WR_SEL_OUT <= s_RF_WR_SEL_IN;
    ALU_OP_SEL_OUT <= s_ALU_OP_SEL_IN;
    ALU_SEL_OUT  <= s_ALU_SEL_IN;
    SP_LD_OUT <= s_SP_LD_IN;
    SP_INCR_OUT  <= s_SP_INCR_IN;
    SP_DECR_OUT <= s_SP_DECR_IN;
    SCR_WE_OUT <= s_SCR_WE_IN;
    SCR_ADDR_SEL_OUT <= s_SCR_ADDR_SEL_IN;
    SCR_DATA_SEL_OUT  <= s_SCR_DATA_SEL_IN;
    FLG_C_SET_OUT <= s_FLG_C_SET_IN;
    FLG_C_CLR_OUT <= s_FLG_C_CLR_IN;
    FLG_C_LD_OUT <= s_FLG_C_LD_IN;
    FLG_Z_LD_OUT <= s_FLG_Z_LD_IN;
    FLG_LD_SEL_OUT <= s_FLG_LD_SEL_IN;
    FLG_SHAD_LD_OUT <= s_FLG_SHAD_LD_IN;
    RST_OUT  <= s_RST_IN;

end Behavioral;
