const std = @import("std");

const Context = @import("context.zig").Context;
const Request = @import("request.zig").Request;
const Response = @import("response.zig").Response;

const allocator = std.heap.page_allocator;

pub const Handler = @This();
const Self = @This();
handlerFn: HandlerFn,

pub const HandlerFn = *const fn (*Context, *Request, *Response) anyerror!void;

// // HandlersChain defines a HandlerFn slice.
// pub const HandlersChain: std.ArrayList(HandlerFn) = std.ArrayList(HandlerFn).init(allocator);
// pub fn last(self: HandlersChain) HandlerFn {
//     return self.getLast();
// }

pub const Chain = struct {
    handler: HandlerFn,
    next: *Chain,
};

pub const HandlersChain: std.ArrayList(Chain) = std.ArrayList(Chain).init(allocator);

pub fn last(self: *HandlersChain) *Chain {
    return self.*.getLast();
}

pub fn append(self: *HandlersChain, handler: HandlerFn) void {
    self.append(.{ .handler = handler, .next = null });
}

pub fn link(self: *HandlersChain, handler: HandlerFn) *Chain {
    const lasHandler = self.last();
    const chain = Chain{
        .handler = handler,
        .next = null,
    };
    if (lasHandler != null) {
        lasHandler.next = &chain;
    }
    self.append(handler);
    return &chain;
}

pub fn Action(comptime G: type) type {
    if (G == void) {
        return *const fn (*Request, *Response) anyerror!void;
    }
    return *const fn (G, *Request, *Response) anyerror!void;
}

pub fn HandleAction(comptime t: type) type {
    if (t == void) {
        return *const fn (*Context, *Request, *Response) anyerror!void;
    }
    return *const fn (t, *Context, *Request, *Response) anyerror!void;
}
