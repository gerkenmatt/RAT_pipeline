----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2018 03:39:57 PM
-- Design Name: 
-- Module Name: buffer3 - Behavioral
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

entity buffer3 is
  Port (CLK             : in STD_LOGIC;
--        RF_WR_IN        : in STD_LOGIC;
--        RF_WR_SEL_IN    : in STD_LOGIC_VECTOR(1 downto 0);
--        ALU_RES_IN      : in STD_LOGIC_VECTOR(7 downto 0);
--        SCR_DATA_IN     : in STD_LOGIC_VECTOR(9 downto 0);
--        SP_DATA_IN      : in STD_LOGIC_VECTOR(7 downto 0);
        IR_IN           : in STD_LOGIC_VECTOR(4 downto 0);
        C_FLAG_IN       : in STD_LOGIC;
        Z_FLAG_IN       : in STD_LOGIC;
        
--        RF_WR_OUT       : out STD_LOGIC;
--        RF_WR_SEL_OUT   : out STD_LOGIC_VECTOR(1 downto 0);
--        ALU_RES_OUT     : out STD_LOGIC_VECTOR(7 downto 0);
--        SCR_DATA_OUT    : out STD_LOGIC_VECTOR(9 downto 0);
--        SP_DATA_OUT     : out STD_LOGIC_VECTOR(7 downto 0);
        IR_OUT          : out STD_LOGIC_VECTOR(4 downto 0);
        C_FLAG_OUT      : out STD_LOGIC;
        Z_FLAG_OUT      : out STD_LOGIC);
end buffer3;

architecture Behavioral of buffer3 is

--signal s_RF_WR_IN        : STD_LOGIC;
--signal s_RF_WR_SEL_IN    : STD_LOGIC_VECTOR(1 downto 0);
--signal s_ALU_RES_IN      : STD_LOGIC_VECTOR(7 downto 0);
--signal s_SCR_DATA_IN     : STD_LOGIC_VECTOR(9 downto 0);
--signal s_SP_DATA_IN      : STD_LOGIC_VECTOR(7 downto 0);
signal s_IR_IN           : STD_LOGIC_VECTOR(4 downto 0);
signal s_C_FLG           : STD_LOGIC;
signal s_Z_FLG           : STD_LOGIC;

begin

    latch: process(CLK)
    begin
        if(RISING_EDGE(CLK)) then
--            s_RF_WR_IN         <= RF_WR_IN;
--            s_RF_WR_SEL_IN     <= RF_WR_SEL_IN;
--            s_ALU_RES_IN       <= ALU_RES_IN;
--            s_SCR_DATA_IN      <= SCR_DATA_IN;
--            s_SP_DATA_IN       <= SP_DATA_IN;
            s_IR_IN            <= IR_IN;
            s_C_FLG            <= C_FLAG_IN;
            s_Z_FLG            <= Z_FLAG_IN;
        end if;
    end process latch;
    
--    RF_WR_OUT         <= s_RF_WR_IN;
--    RF_WR_SEL_OUT     <= s_RF_WR_SEL_IN;
--    ALU_RES_OUT       <= s_ALU_RES_IN;
--    SCR_DATA_OUT      <= s_SCR_DATA_IN;
--    SP_DATA_OUT       <= s_SP_DATA_IN;
    IR_OUT            <= s_IR_IN;
    C_FLAG_OUT        <= s_C_FLG;
    Z_FLAG_OUT        <= s_Z_FLG;

end Behavioral;

