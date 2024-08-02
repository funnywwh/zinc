# zinc

----

Zinc is a high-performance web framework written in Zig(Ziglang).


### Usage.
```zig
const z = @import("zinc");

pub fn main() !void {
    var zinc = try z.Engine.init(.{ .port = 8080 });

    var router = zinc.getRouter();
    try router.get("/", helloWorld);
    try router.get("/ping", pong);

    var catchers = zinc.getCatchers();
    try catchers.put(.not_found, notFound);

    try zinc.run();
}


fn pong(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.Text(.{}, "pong!");
}

fn helloWorld(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.JSON(.{}, .{ .message = "Hello, World!" });
}

fn notFound(ctx: *z.Context, _: *z.Request, _: *z.Response) anyerror!void {
    try ctx.HTML(.{
        .status = .not_found,
    },"<h1>404 Not Found</h1>" );
}
```