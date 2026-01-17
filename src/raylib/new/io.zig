const std = @import("std");

const math = @import("math.zig");
const Vector2 = math.Vector2;

const uncategorized = @import("uncategorized.zig");
const Image = uncategorized.Image;

extern fn EnableEventWaiting() void;
/// Enable waiting for events on EndDrawing(), no automatic event polling
pub fn enableEventWaiting() void {
    EnableEventWaiting();
}

extern fn DisableEventWaiting() void;
/// Disable waiting for events on EndDrawing(), automatic events polling
pub fn disableEventWaiting() void {
    DisableEventWaiting();
}

pub const keyboard = struct {
    extern fn IsKeyPressed(key: c_int) bool;
    /// Check if a key has been pressed once
    pub fn isPressed(key: Key) bool {
        return IsKeyPressed(@intFromEnum(key));
    }

    extern fn IsKeyPressedRepeat(key: c_int) bool;
    /// Check if a key has been pressed again
    pub fn isPressedRepeat(key: Key) bool {
        return IsKeyPressedRepeat(@intFromEnum(key));
    }

    extern fn IsKeyDown(key: c_int) bool;
    /// Check if a key is being pressed
    pub fn isDown(key: Key) bool {
        return IsKeyDown(@intFromEnum(key));
    }

    extern fn IsKeyReleased(key: c_int) bool;
    /// Check if a key has been released once
    pub fn isReleased(key: Key) bool {
        return IsKeyReleased(@intFromEnum(key));
    }

    extern fn IsKeyUp(key: c_int) bool;
    /// Check if a key is NOT being pressed
    pub fn isUp(key: Key) bool {
        return IsKeyUp(@intFromEnum(key));
    }

    extern fn GetKeyPressed() c_int;
    /// Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty
    pub fn getPressed() Key {
        return @enumFromInt(GetKeyPressed());
    }

    extern fn GetCharPressed() c_int;
    /// Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty
    pub fn getPressedChar() i32 {
        return GetCharPressed();
    }

    extern fn GetKeyName(key: c_int) [*c]const u8;
    /// Get name of a QWERTY key on the current keyboard layout (eg returns string 'q' for KEY_A on an AZERTY keyboard)
    pub fn getName(key: Key) [:0]const u8 {
        return std.mem.span(GetKeyName(@intFromEnum(key)));
    }

    extern fn SetExitKey(key: c_int) void;
    /// Set a custom key to exit program (default is ESC)
    pub fn setExitKey(key: Key) void {
        SetExitKey(@intFromEnum(key));
    }

    pub const Key = enum(c_int) {
        null = 0,
        apostrophe = 39,
        comma = 44,
        minus = 45,
        period = 46,
        slash = 47,
        zero = 48,
        one = 49,
        two = 50,
        three = 51,
        four = 52,
        five = 53,
        six = 54,
        seven = 55,
        eight = 56,
        nine = 57,
        semicolon = 59,
        equal = 61,
        a = 65,
        b = 66,
        c = 67,
        d = 68,
        e = 69,
        f = 70,
        g = 71,
        h = 72,
        i = 73,
        j = 74,
        k = 75,
        l = 76,
        m = 77,
        n = 78,
        o = 79,
        p = 80,
        q = 81,
        r = 82,
        s = 83,
        t = 84,
        u = 85,
        v = 86,
        w = 87,
        x = 88,
        y = 89,
        z = 90,
        space = 32,
        escape = 256,
        enter = 257,
        tab = 258,
        backspace = 259,
        insert = 260,
        delete = 261,
        right = 262,
        left = 263,
        down = 264,
        up = 265,
        page_up = 266,
        page_down = 267,
        home = 268,
        end = 269,
        caps_lock = 280,
        scroll_lock = 281,
        num_lock = 282,
        print_screen = 283,
        pause = 284,
        f1 = 290,
        f2 = 291,
        f3 = 292,
        f4 = 293,
        f5 = 294,
        f6 = 295,
        f7 = 296,
        f8 = 297,
        f9 = 298,
        f10 = 299,
        f11 = 300,
        f12 = 301,
        left_shift = 340,
        left_control = 341,
        left_alt = 342,
        left_super = 343,
        right_shift = 344,
        right_control = 345,
        right_alt = 346,
        right_super = 347,
        kb_menu = 348,
        left_bracket = 91,
        backslash = 92,
        right_bracket = 93,
        grave = 96,
        kp_0 = 320,
        kp_1 = 321,
        kp_2 = 322,
        kp_3 = 323,
        kp_4 = 324,
        kp_5 = 325,
        kp_6 = 326,
        kp_7 = 327,
        kp_8 = 328,
        kp_9 = 329,
        kp_decimal = 330,
        kp_divide = 331,
        kp_multiply = 332,
        kp_subtract = 333,
        kp_add = 334,
        kp_enter = 335,
        kp_equal = 336,
        back = 4,
        //menu = 82,
        volume_up = 24,
        volume_down = 25,
    };
};

pub const clipboard = struct {
    extern fn SetClipboardText(text: [*c]const u8) void;
    /// Set clipboard text content
    pub fn setText(text: [:0]const u8) void {
        SetClipboardText(@ptrCast(text));
    }

    extern fn GetClipboardText() [*c]const u8;
    /// Get clipboard text content
    pub fn getText() [:0]const u8 {
        return std.mem.span(GetClipboardText());
    }

    extern fn GetClipboardImage() Image;
    /// Get clipboard image content
    pub fn getImage() Image {
        return GetClipboardImage();
    }
};

pub const mouse = struct {
    extern fn GetMouseX() c_int;
    /// Get mouse position X
    pub fn getX() i32 {
        return GetMouseX();
    }

    extern fn GetMouseY() c_int;
    /// Get mouse position Y
    pub fn getY() i32 {
        return GetMouseY();
    }

    extern fn GetMousePosition() Vector2;
    /// Get mouse position XY
    pub fn getPosition() Vector2 {
        return GetMousePosition();
    }

    extern fn GetMouseDelta() Vector2;
    /// Get mouse delta between frames
    pub fn getDelta() Vector2 {
        return GetMouseDelta();
    }

    extern fn SetMousePosition(x: c_int, y: c_int) void;
    /// Set mouse position XY
    pub fn setPosition(x: i32, y: i32) void {
        SetMousePosition(x, y);
    }

    extern fn SetMouseOffset(offsetX: c_int, offsetY: c_int) void;
    /// Set mouse offset
    pub fn setOffset(offsetX: i32, offsetY: i32) void {
        SetMouseOffset(offsetX, offsetY);
    }

    extern fn SetMouseScale(scaleX: f32, scaleY: f32) void;
    /// Set mouse scaling
    pub fn setScale(scaleX: f32, scaleY: f32) void {
        SetMouseScale(scaleX, scaleY);
    }

    extern fn GetMouseWheelMove() f32;
    /// Get mouse wheel movement for X or Y, whichever is larger
    pub fn getWheelMove() f32 {
        return GetMouseWheelMove();
    }

    extern fn GetMouseWheelMoveV() Vector2;
    /// Get mouse wheel movement for both X and Y
    pub fn getWheelMoveV() Vector2 {
        return GetMouseWheelMoveV();
    }

    extern fn SetMouseCursor(cursor: c_int) void;
    /// Set mouse cursor
    pub fn setCursor(cursor: Cursor) void {
        SetMouseCursor(@intFromEnum(cursor));
    }

    pub const Button = enum(c_int) {
        left = 0,
        right = 1,
        middle = 2,
        side = 3,
        extra = 4,
        forward = 5,
        back = 6,

        extern fn IsMouseButtonUp(button: c_int) bool;
        /// Check if a mouse button is NOT being pressed
        pub fn isUp(self: Button) bool {
            return IsMouseButtonUp(@intFromEnum(self));
        }

        extern fn IsMouseButtonDown(button: c_int) bool;
        /// Check if a mouse button is being pressed
        pub fn isDown(self: Button) bool {
            return IsMouseButtonDown(@intFromEnum(self));
        }

        extern fn IsMouseButtonPressed(button: c_int) bool;
        /// Check if a mouse button has been pressed once
        pub fn isPressed(self: Button) bool {
            return IsMouseButtonPressed(@intFromEnum(self));
        }

        extern fn IsMouseButtonReleased(button: c_int) bool;
        /// Check if a mouse button has been released once
        pub fn isReleased(self: Button) bool {
            return IsMouseButtonReleased(@intFromEnum(self));
        }
    };

    pub const Cursor = enum(c_int) {
        default = 0,
        arrow = 1,
        ibeam = 2,
        crosshair = 3,
        pointing_hand = 4,
        resize_ew = 5,
        resize_ns = 6,
        resize_nwse = 7,
        resize_nesw = 8,
        resize_all = 9,
        not_allowed = 10,

        extern fn ShowCursor() void;
        /// Shows cursor
        pub fn show() void {
            ShowCursor();
        }

        extern fn HideCursor() void;
        /// Hides cursor
        pub fn hide() void {
            HideCursor();
        }

        extern fn IsCursorHidden() bool;
        /// Check if cursor is not visible
        pub fn isHidden() bool {
            return IsCursorHidden();
        }

        extern fn EnableCursor() void;
        /// Enables cursor (unlock cursor)
        pub fn enable() void {
            EnableCursor();
        }

        extern fn DisableCursor() void;
        /// Disables cursor (lock cursor)
        pub fn disable() void {
            DisableCursor();
        }

        extern fn IsCursorOnScreen() bool;
        /// Check if cursor is on the screen
        pub fn isOnScreen() bool {
            return IsCursorOnScreen();
        }
    };
};
