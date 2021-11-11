--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:29:50 11/01/2021
-- Design Name:   
-- Module Name:   C:/Xilinx/my_girassol/my_girassol/my_girassol_test_bench.vhd
-- Project Name:  my_girassol
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: my_girassol
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY my_girassol_test_bench IS
END my_girassol_test_bench;
 
ARCHITECTURE hardware OF my_girassol_test_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT my_girassol
    PORT(
         rst : IN  std_logic;
         clock : IN  std_logic;
         S1 : IN  std_logic;
         S2 : IN  std_logic;
         FC1 : IN  std_logic;
         FC2 : IN  std_logic;
         Motor : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clock : std_logic := '0';
   signal S1 : std_logic := '0';
   signal S2 : std_logic := '0';
   signal FC1 : std_logic := '0';
   signal FC2 : std_logic := '0';

 	--Outputs
   signal Motor : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clock_period : time := 20 ns; 				--clock de 50MHz(conforme especificado no problema)
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: my_girassol PORT MAP (
          rst => rst,
          clock => clock,
          S1 => S1,
          S2 => S2,
          FC1 => FC1,
          FC2 => FC2,
          Motor => Motor
        );

   -- Clock process definitions
   clock_process :process						-- inicio do proceso de clock
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process clock_process;						-- final do processo de clock
 

   -- Stimulus process
   stim_proc: process							-- inicio do processo de estimulos
   begin		
      -- hold reset state for 100 ns.
		rst<='1';						-- reset recebe 1 para aguardar o sistema ligar
      wait for 100 ns;							-- espera 100ns	
		rst<='0';						-- reset recebe 0

		-- estímulos
		S1<='0';						-- sensor de luz 1 sem detectar luz
		S2<='0';						-- sensor de luz 2 sem detectar luz
		FC1<='0';						-- sensor de fim de curso 1 sem detectar o final do curso
		FC2<='0';						-- sensor de fim de curso 2 sem detectar o final do curso
		wait for clock_period*25;				-- espera 25 periodos de clock
		S1<='1';						-- sensor de luz 1 começa a detectar luz
		wait for clock_period*50;				-- espera 50 periodos de clock
		FC2<='1';						-- fim de curso 2 detecta o final do curso
		wait for clock_period*50;				-- espera 50 periodos de clock
		FC1<='1';					   	-- fim de curso 1 detecta o final do curso
		FC2<='0';						-- fim de curso 2 deixa de detectar o final do curso
		wait for clock_period*50;				-- espera 50 periodos de clock
		S1<='0';						-- sensor de luz 1 deixa de detectar luz
		S2<='1';						-- sensor de luz 2 começa a detectar luz
		wait for clock_period*50;				-- espera 50 periodos de clock
		FC1<='0';						-- fim de curso 1 deixa de detectar o final do curso
		FC2<='1';						-- fim de curso 2 detecta o final do curso
		wait for clock_period*50;				-- espera 50 periodos de clock
		FC2<='0';						-- fim de curso 2 deixa de detectar o final do curso
		wait for clock_period*50;				-- espera 50 periodos de clock
		S1<='1';						-- sensor de luz 1 começa a detectar luz
		
      wait;								-- aguarda sem fazer mais nada
   end process stim_proc;						-- final do processo de estímulos

END;									-- fim
