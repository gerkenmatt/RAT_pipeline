----------------------------------------------------------------------------------
-- Engineers: Kyle Wuerch & Chin Chao
-- Module Name: MAIN_CLK_DIV - Behavioral
-- Comment: This module divides the clock in half
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAIN_CLK_DIV is
    Port ( CLK : in STD_LOGIC;
           SCLK : out STD_LOGIC);
end MAIN_CLK_DIV;

architecture Behavioral of MAIN_CLK_DIV is
signal div_clk : STD_LOGIC := '0';

begin

div: process(CLK)
    begin
        if(RISING_EDGE(CLK))then
            div_clk <= NOT div_clk;
        end if;
end process div;

SCLK <= div_clk;

end Behavioral;
