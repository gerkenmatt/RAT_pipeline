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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


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
        PREV_OP_CODE    : in  STD_LOGIC_VECTOR (6 downto 0);
        PC_CNT_T        : in  STD_LOGIC_VECTOR (9 downto 0);
        PC_CNT_NT       : in  STD_LOGIC_VECTOR (9 downto 0);
        C               : in  STD_LOGIC;
        Z               : in  STD_LOGIC;
        PC_CNT_OUT      : out STD_LOGIC_VECTOR(9 downto 0);
        BR_PC_LD        : out STD_LOGIC;
        BR_NOP_CU       : out STD_LOGIC
        );
        
end branch_pred;

architecture Behavioral of branch_pred is
    
    signal  s_op                : STD_LOGIC_VECTOR(6 downto 0);
    --TODO: make s_brn_wait into a state machine: NO_BRANCH, BRANCH_CHECK, BRANCH_NOP
    signal  s_brn_wait          : STD_LOGIC_VECTOR(1 downto 0) := (others => '0'); --not sure if this should be one or two bits
    -- signal  s_op_prev           : STD_LOGIC_VECTOR(6 downto 0);
    -- signal  s_op_tmp            : STD_LOGIC_VECTOR(6 downto 0);
    signal  s_pc_cnt_t_prev     : STD_LOGIC_VECTOR(9 downto 0);
    signal  s_pc_cnt_nt_prev    : STD_LOGIC_VECTOR(9 downto 0);
    signal  s_br_pred_cu        : STD_LOGIC;
    signal  s_br_nop_stall      : STD_LOGIC;
    
    TYPE state_type is (ST_EXEC, ST_INIT, ST_INT);
    signal PS, NS : state_type;
    
    begin
    
        s_op <= OPCODE_HI_5 & OPCODE_LO_2;
        
        sync_process: process(CLK, OPCODE_HI_5)
            begin
                if(FALLING_EDGE(CLK)) then
--                    s_op_prev   <= s_op_tmp;    
--                    s_op_tmp    <= s_op;
                    BR_PC_LD  <= '0';
--                    BR_NOP_CU   <= '0';         
                    BR_NOP_CU  <= '0';                                             
                    if (s_brn_wait = "00") then
                        if (s_br_nop_stall = '1') then
                            BR_NOP_CU <= '1';
                            s_br_nop_stall <= '0';
                        end if;
                        if (OPCODE_HI_5 = "00101" or OPCODE_HI_5 = "00100") then
                            s_brn_wait          <= "01";
                            s_pc_cnt_t_prev     <= PC_CNT_T;
                            s_pc_cnt_nt_prev    <= PC_CNT_NT;  
                            
                            --take the branch every time
                            BR_PC_LD            <= '1';     
                            PC_CNT_OUT          <= PC_CNT_T;   
                            
                        end if;
                    elsif (s_brn_wait="01") then
 
                        --if branch was not taken
                        --flush subsequent stages
                        --and return to previous state
                        s_brn_wait <= "00";
                        case PREV_OP_CODE is
                            when "0010101" => -- BRCC
                                if(C = '1') then
                                    BR_PC_LD <= '1';
                                    BR_NOP_CU  <= '1';
                                    PC_CNT_OUT <= s_pc_cnt_nt_prev;    
                                    s_brn_wait <= "10";  
                                end if;
                            when "0010100" => -- BRCS
                                if(C = '0') then
                                    BR_PC_LD <= '1';
                                    BR_NOP_CU  <= '1';
                                    PC_CNT_OUT <= s_pc_cnt_nt_prev;
                                    s_brn_wait <= "10";
                                end if;
                            when "0010010" => -- BREQ
                                if(Z = '0') then
                                    BR_PC_LD <= '1';
                                    BR_NOP_CU  <= '1';
                                    PC_CNT_OUT <= s_pc_cnt_nt_prev;
                                    s_brn_wait <= "10";
                                end if;
                            when "0010011" => -- BRNE
                                if(Z = '1') then 
                                    BR_PC_LD <= '1';
                                    BR_NOP_CU  <= '1';
                                    PC_CNT_OUT <= s_pc_cnt_nt_prev;
                                    s_brn_wait <= "10";
                                end if;
                            when others => 
                                BR_PC_LD <= '0';
                                BR_NOP_CU  <= '0';
                                
                            end case;
                        --send no op to alu
--                        s_br_pred_cu <= '0';
                    elsif (s_brn_wait= "10") then
                          --send no op to alu
                          BR_PC_LD <= '0';
                          BR_NOP_CU  <= '1';
                          s_br_nop_stall <= '1';
                          s_brn_wait <= "00";
                    end if;  
                                    
                end if;
                
        end process sync_process;
        
--        comb_proc: process(OPCODE_HI_5, s_brn_wait, PC_CNT_T, PC_CNT_NT)
--        begin
--            if ((OPCODE_HI_5 = "00101" or OPCODE_HI_5 = "00100") and s_brn_wait="00") then
--                s_brn_wait          <= "01";
--                s_pc_cnt_t_prev     <= PC_CNT_T;
--                s_pc_cnt_nt_prev    <= PC_CNT_NT;  
                
--                --take the branch every time
--                BR_PC_LD            <= '1';     
--                PC_CNT_OUT          <= PC_CNT_T;            
--            end if;
--        end process;
            
end Behavioral;
