const std = @import("std");
const http = std.http;
const mem = std.mem;
const server_request = std.http.Server.Request;
const RespondOptions = server_request.RespondOptions;

pub const Request = @This();
const Self = @This();

server_request: *server_request = undefined,

target: []const u8 = undefined,

pub fn init(self: Self) Request {
    if (!std.mem.eql(u8, self.target, "")) {
        return .{
            .server_request = self.server_request,
            .target = self.target,
        };
    }
    return .{
        .server_request = self.server_request,
        .target = self.server_request.head.target,
    };
}

pub fn method(self: *Request) http.Method {
    return self.request.head.method;
}

pub fn send(self: *Request, content: []const u8, options: RespondOptions) !void {
    try self.request.respond(content, options);
}
