--custom state: a and b
--EELE467 Final
--Michael Valentino-Manno
library IEEE;
use IEEE.STD_Logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity st3 is
	port(
		clk : in std_logic;
		reset : in std_logic;
		A : in std_logic_vector(31 downto 0);
		B : in std_logic_vector(31 downto 0);
		Res_High : out std_logic_vector(31 downto 0);
		Res_Low : out std_logic_vector(31 downto 0);
		stat : out std_logic_vector(2 downto 0)
	);
end entity;

architecture st3_arch of st3 is
	--signal to represent the result of the and operation
	signal and_ans : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(0,32));
	
	begin
	
	AND1 : process(clk,reset) --performs the and operation
		begin
				if(reset = '0') then
					and_ans <= std_logic_vector(to_unsigned(0,32));
				elsif(rising_edge(clk)) then
					and_ans <= A AND B;
				end if;
		end process;
		
		
		Res_Low <= and_ans; --saves result to high and low registers
		Res_High <= std_logic_vector(to_unsigned(0,32));
		
		
			ZERO : process(clk, reset) --checks if result is zero
				begin
				if(reset ='0') then
						stat(0) <= '0';
				elsif(rising_edge(clk)) then
					if(and_ans(31 downto 0) = "00000000000000000000000000000000") then
						stat(0) <= '1';
					else
						stat(0) <= '0';
				end if;
			end if;
		end process;
				
	NEG : procesS(clk,reset) --checks if result is negative
		begin
			if(reset = '0') then
					stat(1) <= '0';
			elsif(rising_edge(clk)) then
					stat(1) <= and_ans(31);       --if the leftmost bit is a 1, its negative
				end if;
		end process;
	
	OVRFLW : process(clk,reset)
		begin
			if(reset = '0') then
				stat(2) <= '0';
			elsif(rising_edge(clk)) then
					stat(2) <= '0'; --cant overflow
			end if;
		end process;
				
	
end architecture; 