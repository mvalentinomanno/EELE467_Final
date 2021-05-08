--state 1: a - b
--EELE467 Final
--Michael Valentino-Manno

library IEEE;
use IEEE.STD_Logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity st1 is
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

architecture st1_arch of st1 is
	signal dif : signed(32 downto 0) := to_signed(0,33); --signal to hold result
	
	begin
	
	SUB : process(clk, reset) --subtraction process
		begin
			if(reset = '0') then
				dif <= to_signed(0,33);
			elsif(rising_edge(clk)) then
				dif <= signed('0' & A) - signed('0' & B); --append 0's to make them 33 bits
			end if;
		end process;
		
		Res_Low <= std_logic_vector(dif(31 downto 0));
		Res_High <= std_logic_vector(to_unsigned(0,32)); --cant overflow
		
	ZERO : process(clk, reset) --checks if zero
		begin
				if(reset ='0') then
						stat(0) <= '0';
				elsif(rising_edge(clk)) then
					if(dif(31 downto 0) = x"00") then
						stat(0) <= '1';
					else
						stat(0) <= '0';
				end if;
			end if;
		end process;
				
	NEG : procesS(clk,reset) --checks if negative
		begin
			if(reset = '0') then
					stat(1) <= '0';
			elsif(rising_edge(clk)) then
				if(dif < x"00" and dif(31 downto 0) /= x"00") then --if less than 0
					stat(1) <= '1';
				else
					stat(1) <= '0';
				end if;
			end if;
		end process;
				
				
				
	end architecture;
