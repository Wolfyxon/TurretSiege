return {
    -- TODO: Remove LOVER_VERSION after Lover 1.4 (or 1.3.(x > 1)) is released
    version = os.getenv("LOVER_VERSION") or os.getenv("LOVER_PKG_VERSION") or "0.0.0-unknown",
    windowSizeMultiplier = 3,
    width = 400,
    height = 240,
    flags = {"scene=menu"}
}