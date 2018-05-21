----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2018 08:58:57 AM
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
  Port ( CLK            : in  STD_LOGIC;
        OPCODE_HI_5     : in  STD_LOGIC_VECTOR (4 downto 0);
        OPCODE_LO_2     : in  STD_LOGIC_VECTOR (1 downto 0);
        PC_CNT_T        : in  STD_LOGIC_VECTOR (9 downto 0);
        PC_CNT_NT       : in  STD_LOGIC_VECTOR (9 downto 0);
        C               : in  STD_LOGIC;
        Z               : in  STD_LOGIC;
        PC_CNT_OUT      : out STD_LOGIC_VECTOR(9 downto 0)
        );
        
end branch_pred;

architecture Behavioral of branch_pred is
    
    signal  s_op                : STD_LOGIC_VECTOR(6 downto 0);
    signal  s_brn_wait          : STD_LOGIC_VECTOR(1 downto 0) := (others => '0'); --not sure if this should be one or two bits
    signal  s_op_prev           : STD_LOGIC_VECTOR(6 downto 0);
    signal  s_op_tmp            : STD_LOGIC_VECTOR(6 downto 0);
    signal  s_pc_cnt_t_prev     : STD_LOGIC_VECTOR(9 downto 0);
    signal  s_pc_cnt_nt_prev    : STD_LOGIC_VECTOR(9 downto 0);
    
    begin
    
        s_op <= OPCODE_HI_5 & OPCODE_LO_2;
        
        
        sync_process: process(CLK)
            begin
                if(RISING_EDGE(CLK)) then
                    s_op_prev   <= s_op_tmp;    
                    s_op_tmp    <= s_op;
                    if(s_brn_wait = "01") then
                    
                        --if branch was not taken
                        --flush subsequent stages
                        --and return to previous state
                        case s_op_prev is
                            when "0010101" => -- BRCC
                                if(C = '1') then
                                    PC_CNT_OUT <= s_pc_cnt_nt_prev;      
                                                                
                                end if;
                            when "0010100" => -- BRCS
                                if(C = '0') then
                                    PC_CNT_OUT <= s_pc_cnt_nt_prev;
                                end if;
                            when "0010010" => -- BREQ
                                if(Z = '0') then
                                    PC_CNT_OUT <= s_pc_cnt_nt_prev;
                                end if;
                            when "0010011" => -- BRNE
                                if(Z = '1') then 
                                    PC_CNT_OUT <= s_pc_cnt_nt_prev;
                                end if;
                            end case;
                        --send no op to alu
                        
                        s_brn_wait <= "10";
                    elsif (s_brn_wait="10")
                        
                        --send no op to alu
                        
                    end if;  
                                    
                end if;
                
        end process sync_process;
        
        comb_proc: process(OPCODE_HI_5)
        begin
            if ((OPCODE_HI_5 = "00101" or OPCODE_HI_5 = "00100") and s_brn_wait="00") then
                s_brn_wait          <= "01";
                s_pc_cnt_t_prev     <= PC_CNT_T;
                s_pc_cnt_nt_prev    <= PC_CNT_NT;              
            end if;
        end process;
            
end Behavioral;
