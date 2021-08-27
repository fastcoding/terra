local C = terralib.includecstring [[
    #include <stdio.h>
    typedef union {
            float v[2];
            struct {
                float x;
                float y;
            };
    } float2;
    static float2 a;
    void doit() {
        a.x = 4;
        a.y = 5;
		printf("a.x=%f,a.y=%f\n",a.x,a.y);
    }
    float2* what() { return &a; }
]]

C.float2:printpretty()

local anonstructgetter = macro(function(name,self)
    for i,e in pairs(self:gettype():getfields()) do
        if e.key:match("_%d+") and e.type:getfield(name) then
		    C.printf("macro: %s %s\n",e.key,name)
            return `self.[e.key].[name]
        end
    end 
    error("no field "..name.." in struct of type "..tostring(T))
end)

C.float2.metamethods.__entrymissing = anonstructgetter


tp=tuple(float,float,float,float)
terra foo(pa : &C.float2)
    var a = @C.what()
    return a.v[0],a.v[1],a.x,a.y
end
terra bar(b:tp)
    C.printf("actual:%f %f %f %f\n",b._0,b._1,b._2,b._3);
end

C.doit()
--terralib.saveobj('foo.ll',{foo=foo})
local a = foo(C.what())
bar(a)
print('0',a._0)
print('1',a._1)
print('2',a._2)
print('3',a._3)
assert(4 == a._0)
assert(5 == a._1)
assert(4 == a._2)
assert(5 == a._3)
