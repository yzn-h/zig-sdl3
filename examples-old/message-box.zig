const sdl3 = @import("sdl3");

fn playGame() !bool {
    const val = try sdl3.message_box.show(.{
        .flags = .{},
        .parent_window = null,
        .title = "Question:",
        .message = "What is my favorite color?",
        .buttons = sdl3.message_box.Data.formatButtons(&[_]?sdl3.message_box.Button{ sdl3.message_box.Button{
            .text = "Red",
            .value = 0,
        }, sdl3.message_box.Button{
            .text = "Orange",
            .value = 0,
        }, sdl3.message_box.Button{
            .text = "Yellow",
            .value = 0,
        }, sdl3.message_box.Button{
            .text = "Green",
            .value = 0,
        }, sdl3.message_box.Button{
            .text = "Blue",
            .value = 0,
        }, sdl3.message_box.Button{
            .text = "Purple",
            .value = 1,
        } }),
        .colors = null,
    });
    if (val != 1) {
        _ = try sdl3.message_box.show(.{
            .flags = .{ .error_dialog = true },
            .parent_window = null,
            .title = "Wrong!",
            .message = "You have chosen the wrong answer. Please try again.",
            .buttons = sdl3.message_box.Data.formatButtons(&[_]?sdl3.message_box.Button{
                sdl3.message_box.Button{
                    .text = "I Understand",
                    .value = 0,
                },
            }),
            .colors = .{
                .background = sdl3.message_box.Color.init(10, 10, 10),
                .text = try sdl3.message_box.Color.fromHex("ffffff"),
                .button_border = .{ .r = 75, .g = 55, .b = 50 },
                .button_background = sdl3.message_box.Color.init(160, 20, 20),
                .button_selected = try sdl3.message_box.Color.fromHex("fdfd22"),
            },
        });
        return false;
    } else {
        _ = try sdl3.message_box.show(.{
            .flags = .{ .information_dialog = true },
            .parent_window = null,
            .title = "Correct!",
            .message = "You have guessed correctly. Yippee!",
            .buttons = sdl3.message_box.Data.formatButtons(&[_]?sdl3.message_box.Button{
                sdl3.message_box.Button{
                    .text = "Bye!",
                    .value = 0,
                },
            }),
            .colors = .{
                .background = sdl3.message_box.Color.init(195, 195, 195),
                .text = try sdl3.message_box.Color.fromHex("660aa8"),
                .button_border = .{ .r = 50, .g = 75, .b = 55 },
                .button_background = sdl3.message_box.Color.init(20, 160, 20),
                .button_selected = try sdl3.message_box.Color.fromHex("fdfd22"),
            },
        });
        return true;
    }
}

pub fn main() !void {
    try sdl3.message_box.showSimple(.{}, "Start!", "Get ready to play the game.", null);
    while (true) {
        if (try playGame())
            break;
    }
}
