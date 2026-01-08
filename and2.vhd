entity and2_gate is
port( in_1, in_2: in bit;
output
: out bit);
end;
architecture example of and2_gate is
begin
output <= in_1 and in_2;
end;
