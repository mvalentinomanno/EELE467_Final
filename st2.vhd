--custom state: a * b
--EELE467 Final
--Michael Valentino-Manno

library IEEE;
use IEEE.STD_Logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity st2 is
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

architecture st2_arch of st2 is
	signal prod : signed(63 downto 0) := to_signed(0,64); --signal holds product
	
	begin
	
	MUL : process(clk, reset) --performs multiplication
		begin
			if(reset = '0') then
				prod <= to_signed(0,64);
			elsif(rising_edge(clk)) then
				prod <= signed(A) * signed(B);
			end if;
		end process;
		
		Res_Low <= std_logic_vector(prod(31 downto 0));
		Res_High <= std_logic_vector(prod(63 downto 32)); --can overflow
		
	ZERO : process(clk, reset) --sets zero flag
		begin
				if(reset ='0') then
						stat(0) <= '0';
				elsif(rising_edge(clk)) then
					if(prod(63 downto 0) = x"00") then
						stat(0) <= '1';
					else
						stat(0) <= '0';
				end if;
			end if;
		end process;
				
	NEG : process(clk,reset) --sets negative flag
		begin
			if(reset = '0') then
					stat(1) <= '0';
			elsif(rising_edge(clk)) then
				if(prod(63 downto 0) < x"00" and prod(63 downto 0) /= x"00") then
					stat(1) <= '1';
				else
					stat(1) <= '0';
				end if;
			end if;
		end process;
		
	OVRFLW : process(clk,reset) --overflow flag
		begin
			if(reset = '0') then
				stat(2) <= '0';
			elsif(rising_edge(clk)) then
				if(prod(63 downto 32) = x"00" or (prod(63 downto 32) = x"FF")) then --the FF check takes care of a strange case i was encountering, where it would detect an overflow when there wasnt
					stat(2) <= '0';
				else
					stat(2) <= '1';
				end if;
			end if;
		end process;
				
				
	end architecture;
