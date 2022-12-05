library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity rom is
    generic(
        N : natural := 8;
        M : natural := 4
    );
    port(
        pc : in std_logic_vector(M-1 downto 0);
        instr : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture struct of rom is
    type rom_t is array (natural range 0 to 15) of integer;
    constant R : rom_t := (
        0 => 00000000, -- RCSR R0
        1 => 01000001, -- IN R1
        2 => 01000010, -- OUT R1
        3 => 00000010, -- OUT R0
        4 => 00100011, -- MOV R0, R2
        5 => 10000010, -- OUT R2
        6 => 10110100, -- ADD R2, R3
        7 => 11000010, -- OUT R3
        8 => 10110101, -- MUL R2, R3
        9 => 11000010, -- OUT R3
        10 => 01000110, -- LSL R1
        11 => 01000010, -- OUT R1 
        12 => 10000111, -- LSR R2
        13 => 10000010, -- OUT R2
        14 => 10110011, -- MOV R2, R3
        15 => 11000010 -- OUT R3
    );
begin
    instr <= std_logic_vector(to_signed(R(to_integer(unsigned(pc))),6));
end architecture;