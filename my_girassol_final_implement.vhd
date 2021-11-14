----------------------------------------------------------------------------------
-- Girassol Mecânico descrito em VHDL
-- 
-- Seis entradas: S1, S2, FC1, FC2, clock e rst - dois sensores de luz, dois sensores fim de curso, um clock e um reset
--
-- Quatro saídas: Passos de quatro estados - do motor de passo
--
-- Create Date:    14:28:58 10/31/2021 
--
-- Module Name:    my_girassol - Behavioral
--
-- Project Name: my_girassol
--
-- Autores: Adevair Vitório, Fábio Miranda, Marlon Costa, Maysa Batista, Robson Gross
--
-- Data: Outubro de 2021
----------------------------------------------------------------------------------
library IEEE;							-- Indica utiliza as bibliotecas do Instituto de Engenheiros Elétricos e Eletrônicos
use IEEE.STD_LOGIC_1164.ALL;					-- Utiliza a biblioteca padrão 1164

entity my_girassol is port					-- Declaraçao da entidade
(
	rst   :	in	 std_logic;				-- entrada de reset
	clock :	in	 std_logic;				-- entrada do clock
	S1    :	in  std_logic;	 				-- entrada digital S1
	S2    :	in  std_logic; 					-- entrada digital S2
	FC1   :	in  std_logic; 					-- entrada digital FC1
	FC2   :	in  std_logic; 					-- entrada digital FC2
	Motor :	out std_logic_vector(3 downto 0) 		-- vetor de saída para as fases do motor de passo
	
);
end my_girassol;						-- Final da declaraçao da entidade

architecture hardware of my_girassol is				-- início da arquitetura
	--                    passos do motor
	type state is (passo_1, passo_2, passo_3, passo_4); 	-- novo tipo definido
	signal passos : state;                              	-- sinal do tipo state
	begin							-- inicia o hardware
	my_process : process(S1, S2, FC1, FC2, clock, rst)
	begin
		if (rst = '1') then				-- passo inicial
			passos <= passo_1;			-- passo_1
		elsif (clock'event and clock = '1') then	-- ciclo dos passos
			case passos is
				when passo_1 =>
					if ((S1 = '0' and S2 = '0') or (FC1 = '1' and FC2 = '1') or (S1 = '1' and FC1 = '1') or (S2 = '1' and FC2 = '1')) then
						passos <= passo_1;
					elsif (S1 = '1' and FC1 = '0') then
						passos <= passo_2;
					elsif (S2 = '1' and FC2 = '0') then
						passos <= passo_4;
					end if;
				when passo_2 =>
					if ((S1 = '0' and S2 = '0') or (FC1 = '1' and FC2 = '1') or (S1 = '1' and FC1 = '1') or (S2 = '1' and FC2 = '1')) then
						passos <= passo_2;
					elsif (S1 = '1' and FC1 = '0') then
						passos <= passo_3;
					elsif (S2 = '1' and FC2 = '0') then
						passos <= passo_1;
					end if;
				when passo_3 =>
					if ((S1 = '0' and S2 = '0') or (FC1 = '1' and FC2 = '1') or (S1 = '1' and FC1 = '1') or (S2 = '1' and FC2 = '1')) then
						passos <= passo_3;
					elsif (S1 = '1' and FC1 = '0') then
						passos <= passo_4;
					elsif (S2 = '1' and FC2 = '0') then
						passos <= passo_2;
					end if;
				when passo_4 =>
					if ((S1 = '0' and S2 = '0') or (FC1 = '1' and FC2 = '1') or (S1 = '1' and FC1 = '1') or (S2 = '1' and FC2 = '1')) then
						passos <= passo_4;
					elsif (S1 = '1' and FC1 = '0') then
						passos <= passo_1;
					elsif (S2 = '1' and FC2 = '0') then
						passos <= passo_3;
					end if;
			end case;
		end if;
	end process my_process;
	
	with passos select					-- decodifica os passos
		Motor <= "1010" when passo_1, 			-- Passo 1
			 "1001" when passo_2, 			-- Passo 2
			 "0101" when passo_3, 			-- Passo 3
			 "0110" when passo_4; 			-- Passo 4

end hardware;							-- final do hardware
