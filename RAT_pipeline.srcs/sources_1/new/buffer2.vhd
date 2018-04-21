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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity buffer2 is
  Port (CLK         : in STD_LOGIC;
        IR_IN       : in STD_LOGIC_VECTOR(17 downto 0);
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
        
        IR_OUT      : out STD_LOGIC_VECTOR(17 downto 0); 
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

signal val : STD_LOGIC; 

begin

    latch: process(CLK)
    begin
        if(RISING_EDGE(CLK)) then
            val <= RF_WR_IN;
        end if;
    end process latch;
    
    RF_WR_OUT <= val;

end Behavioral;
