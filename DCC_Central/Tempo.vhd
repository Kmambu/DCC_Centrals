----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2018 09:54:19 AM
-- Design Name: 
-- Module Name: Tempo - Behavioral
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

entity Tempo is
    Port ( Clk_1MHz : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Com_Tempo : in STD_LOGIC;
           Fin_Tempo : out STD_LOGIC);
end Tempo;

architecture Behavioral of Tempo is
signal cur_cpt, next_cpt : integer range 0 to 6000;
type state_type is (IDLE_ST, COUNT_ST);
signal cur_state, next_state : state_type;
begin
clocked : process(Clk_1MHz, Reset, Com_Tempo)
begin
    if Reset = '1' then
        cur_cpt <= 0;
        cur_state <= IDLE_ST;
    elsif rising_edge(Clk_1MHz) then
        cur_cpt <= next_cpt;
        cur_state <= next_state;
    end if;
end process clocked;

state_updt : process (cur_state, Com_Tempo, cur_cpt)
begin
    case cur_state is
        when IDLE_ST =>
            next_cpt <= 0;
            Fin_Tempo <= '0';
            if Com_Tempo = '1' then
                next_state <= COUNT_ST;
            else
                next_state <= IDLE_ST;
            end if;
        when COUNT_ST =>
            if cur_cpt = 5999 then
                next_state <= IDLE_ST;
                Fin_Tempo <= '1';
            else
                next_state <= COUNT_ST;
                Fin_Tempo <= '0';
            end if;
            next_cpt <= cur_cpt + 1;
    end case;
end process state_updt;
end Behavioral;
