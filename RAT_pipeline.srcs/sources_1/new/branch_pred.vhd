----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/22/2018 08:41:20 AM
-- Design Name: 
-- Module Name: branch_pred - Behavioral
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

entity branch_pred is

  Port (CLK             : in STD_LOGIC;
      INSTR             : in STD_LOGIC_VECTOR(17 downto 0);
      INSTR_OLD         : in STD_LOGIC_VECTOR(17 downto 0);
      GUESS             : in STD_LOGIC;
      PC_COUNT_IN       : in STD_LOGIC_VECTOR(9 downto 0);
      PC_COUNT_ALT_IN   : in STD_LOGIC_VECTOR(9 downto 0);
      C_FLAG            : in STD_LOGIC;
      Z_FLAG            : in STD_LOGIC;
 
      PC_LD             : out STD_LOGIC;
      PC_MUX_SEL        : out STD_LOGIC_VECTOR(1 downto 0);
      PC_COUNT          : out STD_LOGIC_VECTOR(9 downto 0);
      PC_COUNT_ALT_OUT  : out STD_LOGIC_VECTOR(9 downto 0);
      INSTR_OUT         : out STD_LOGIC_VECTOR(17 downto 0));
end branch_pred;

architecture Behavioral of branch_pred is

--helpful aliases
alias OP_HI  : STD_LOGIC_VECTOR(4 downto 0) is INSTR (17 downto 13);
alias OP_LOW : STD_LOGIC_VECTOR(1 downto 0) is INSTR (1 downto 0);
alias OP_HI_OLD  : STD_LOGIC_VECTOR(4 downto 0) is INSTR_OLD (17 downto 13);
alias OP_LOW_OLD : STD_LOGIC_VECTOR(1 downto 0) is INSTR_OLD (1 downto 0);

signal s_pc_ld : STD_LOGIC := '0';
signal s_op_low: STD_LOGIC_VECTOR(1 downto 0);
signal s_op_low_old: STD_LOGIC_VECTOR(1 downto 0);
signal s_op_hi: STD_LOGIC_VECTOR(4 downto 0);
signal s_op_hi_old: STD_LOGIC_VECTOR(4 downto 0);

begin
    thing: process(CLK)
    begin
        if(FALLING_EDGE(CLK)) then
            if((OP_HI_OLD = "00101" and OP_LOW_OLD = "01")) then --BRCC
                if(GUESS = '1' and C_FLAG = '1') then --GUESSED TAKEN BUT SHOULDNT
                    s_pc_ld <= '1';
                    PC_COUNT <= PC_COUNT_ALT_IN;
                elsif(GUESS = '0' and C_FLAG = '0') then --GUESSED NOT TAKEN BUT SHOULD
                    s_pc_ld <= '1';
                    PC_COUNT <= INSTR_OLD(12 downto 3);
                end if;
                
            elsif((OP_HI_OLD = "00101" and OP_LOW_OLD = "00")) then --BRCS
                if(GUESS = '1' and C_FLAG = '0') then --GUESSED TAKEN BUT SHOULDNT
                    s_pc_ld <= '1';
                    PC_COUNT <= PC_COUNT_ALT_IN;
                elsif(GUESS = '0' and C_FLAG = '1') then --GUESSED NOT TAKEN BUT SHOULD
                    s_pc_ld <= '1';
                    PC_COUNT <= INSTR_OLD(12 downto 3);
                end if;
                
            elsif((OP_HI_OLD = "00100" and OP_LOW_OLD = "10")) then --BREQ
                if(GUESS = '1' and Z_FLAG = '0') then --GUESSED TAKEN BUT SHOULDNT
                    s_pc_ld <= '1';
                    PC_COUNT <= PC_COUNT_ALT_IN;
                elsif(GUESS = '0' and Z_FLAG = '1') then --GUESSED NOT TAKEN BUT SHOULD
                    s_pc_ld <= '1';
                    PC_COUNT <= INSTR_OLD(12 downto 3);
                end if; 
                
            elsif((OP_HI_OLD = "00100" and OP_LOW_OLD = "11")) then --BRNE
                if(GUESS = '1' and Z_FLAG = '0') then --GUESSED TAKEN BUT SHOULDNT
                    s_pc_ld <= '1';
                    PC_COUNT <= PC_COUNT_ALT_IN;
                elsif(GUESS = '0' and Z_FLAG = '1') then --GUESSED NOT TAKEN BUT SHOULD
                    s_pc_ld <= '1';
                    PC_COUNT <= INSTR_OLD(12 downto 3);
                end if;
                
            elsif((OP_HI = "00101" and OP_LOW = "01") or --BRCC
                  (OP_HI = "00101" and OP_LOW = "00") or --BRCS
                  (OP_HI = "00100" and OP_LOW = "10") or --BREQ
                  (OP_HI = "00100" and OP_LOW = "11")) then --BRNE
                     s_pc_ld <= '1';
                     PC_MUX_SEL <= "11";
                     PC_COUNT <= INSTR(12 downto 3);
                     PC_COUNT_ALT_OUT <= PC_COUNT_IN;
            else
                s_pc_ld <= '0';
                PC_MUX_SEL <= "00"; 
                
            end if;
            INSTR_OUT <= INSTR;
        end if;
        if(RISING_EDGE(CLK)) then
            if(s_pc_ld = '1') then
                s_pc_ld <= '0';
            end if;
        end if;
    end process thing;
    
    PC_LD <= s_pc_ld;
    s_op_hi <= OP_HI;
    s_op_hi_old <= OP_HI_OLD;
    s_op_low <= OP_LOW;
    s_op_low_old <= OP_LOW_OLD;
end Behavioral;