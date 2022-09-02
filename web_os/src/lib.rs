use std::{thread, time::Duration};

#[no_mangle]
pub extern "C" fn sum(left: i32, right: i32) -> i32 {
    left + right
}
#[no_mangle]
pub extern "C" fn sum_long_running(left: i32, right: i32) -> i32 {
    thread::sleep(Duration::from_secs(1));
    sum(left, right)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = sum(2, 2);
        assert_eq!(result, 4);
    }
}
