library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAE is 
port (  Clk_100Mhz	: in std_logic;
	Reset   	: in std_logic;
	DCC_bit		: in std_logic;
	Fin_1		: in std_logic;
	Fin_0		: in std_logic;
	Fin_Trame	: in std_logic;
	Fin_Tempo	: in std_logic;
	Com_Reg		: out std_logic;
	Com_Tempo	: out std_logic;
	Go_1		: out std_logic;
	Go_0		: out std_logic);
end MAE;

architecture Behavioral of MAE is 
type state is (IDLE, CONTROL, SEND_1, SEND_0, WAIT_1, WAIT_0, TEMPO);
signal Cur_State, Next_State : state;
begin

process (Clk_100Mhz, reset)
begin
	if Reset = '1' then
	   Cur_State <= IDLE;
	elsif rising_edge (Clk_100Mhz) then
	   Cur_State <= Next_State;
	end if;
end process;

process (Cur_State, DCC_Bit, Fin_1, Fin_0, Fin_Trame, Fin_Tempo)
begin 
	case (Cur_State) is

	when IDLE => 
	   Com_Reg <= '0';
		Com_Tempo <= '0';
		Go_0 <= '0';
		Go_1 <= '0';
		Next_State <= CONTROL;
	when CONTROL =>
		Com_Reg <= '1';
		Com_Tempo <= '0';
		Go_0 <= '0';
        Go_1 <= '0';
 		if DCC_bit = '0' then 
			Next_State <= SEND_0; 
		elsif DCC_bit = '1' then 
            Next_State <= SEND_1; 
		else
		    Next_State <= CONTROL;
		end if;
	when SEND_0 =>
		Com_Reg <= '0';
		Com_Tempo <= '0';
		Go_0 <= '1';
		Go_1 <= '0';
		Next_State <= WAIT_0;
	when WAIT_0 =>
	    Com_Reg <= '0';
        Com_Tempo <= '0';
        Go_0 <= '0';
        Go_1 <= '0';
	    if Fin_0 = '0' then
	        Next_State <= WAIT_0;
	    elsif Fin_0 = '1' then
	        Next_State <= CONTROL;
	    else
	        Next_State <= WAIT_0;
	    end if;
	    when SEND_1 =>
            Com_Reg <= '0';
            Com_Tempo <= '0';
            Go_0 <= '0';
            Go_1 <= '1';
            Next_State <= WAIT_1;
        when WAIT_1 =>
            Com_Reg <= '0';
            Com_Tempo <= '0';
            Go_0 <= '0';
            Go_1 <= '0';
            if Fin_1 = '0' and Fin_Trame = '0' then
                Next_State <= WAIT_1;
            elsif Fin_1 = '1' and Fin_Trame = '0' then
                Next_State <= CONTROL;
            elsif Fin_Trame = '1' then
                Next_State <= TEMPO;
            else
                Next_State <= WAIT_1;
            end if;
	when TEMPO =>
		Com_Reg <= '0';
		Com_Tempo <= '1';
		Go_0 <= '0';
		Go_1 <= '0';
		if Fin_Tempo='1' then
			Next_State <= IDLE;
		elsif Fin_Tempo = '0' then
			Next_State <= TEMPO;
	    else
	        Next_State <= TEMPO;
		end if;
	end case;
end process;
end Behavioral;