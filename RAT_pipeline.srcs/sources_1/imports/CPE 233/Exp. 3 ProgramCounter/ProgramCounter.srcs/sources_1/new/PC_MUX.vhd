----------------------------------------------------------------------------------
-- Engineer: Kyle Wuerch & Chin Chao
--
-- Module Name: PC_MUX - Behavioral
-- Comments: This module selects either its FROM_IMMED, FROM_STACK,
-- or "0x3FF" signal to output based of the given MUX_SELECT input 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC_MUX is
    Port ( MUX_SEL      : in  STD_LOGIC_VECTOR (1 downto 0);
           FROM_IMMED   : in  STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK   : in  STD_LOGIC_VECTOR (9 downto 0);
           FROM_BR_PRED : in  STD_LOGIC_VECTOR (9 downto 0);
           BR_LD        : in  STD_LOGIC;
           MUX_OUT      : out STD_LOGIC_VECTOR (9 downto 0));
end PC_MUX;

architecture Behavioral of PC_MUX is

begin
    
    muxing : process(MUX_SEL, BR_LD, FROM_BR_PRED, FROM_STACK, FROM_IMMED)
    begin
     
        if (BR_LD = '1') then
            MUX_OUT  <= FROM_BR_PRED;
    
        else
            case(MUX_SEL) is
                when "00" => MUX_OUT <= FROM_IMMED;
                when "01" => MUX_OUT <= FROM_STACK;
                when "10" => MUX_OUT <= "11" & x"FF";
                when others => MUX_OUT <= "00" & x"00";
            end case;
        end if;
        
    end process muxing;

end Behavioral;
