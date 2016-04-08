# lla = LatLonAlt(deg2rad(deg_min_sec_to_degrees(73, 0, 0)),
#                 deg2rad(deg_min_sec_to_degrees(45, 0, 0)),
#                 0.0)
# utm = convert(UTM, lla, INTERNATIONAL)
# @printf("%3d %1d %2.3f  %3d %1d %2.3f → ", degrees_to_deg_min_sec(rad2deg(lla.lat))..., degrees_to_deg_min_sec(rad2deg(lla.lon))...)
# @printf("%2d %7.2f  %6.2f\n", utm.zone, utm.n, utm.e)

# lla = LatLonAlt(deg2rad(deg_min_sec_to_degrees( 30, 0, 0)),
#                 deg2rad(deg_min_sec_to_degrees(102, 0, 0)),
#                 0.0)
# utm = convert(UTM, lla, INTERNATIONAL)
# @printf("%3d %1d %2.3f  %3d %1d %2.3f → ", degrees_to_deg_min_sec(rad2deg(lla.lat))..., degrees_to_deg_min_sec(rad2deg(lla.lon))...)
# @printf("%2d %7.2f  %6.2f\n", utm.zone, utm.n, utm.e)

# utm = UTM(210577.93, 3322824.35, 0.0, 48)
# lla_target = LatLonAlt(deg2rad(deg_min_sec_to_degrees(30, 0, 6.489)),
#                        deg2rad(deg_min_sec_to_degrees(101, 59, 59.805)), # E
#                        0.0)
# lla = convert(LatLonAlt, utm, INTERNATIONAL)
# @printf("%3d %1d %2.3f  %3d %1d %2.3f ← ", degrees_to_deg_min_sec(rad2deg(lla.lat))..., degrees_to_deg_min_sec(rad2deg(lla.lon))...)
# @printf("%2d %7.2f  %6.2f\n", utm.zone, utm.n, utm.e)
# @printf("%3d %1d %2.3f  %3d %1d %2.3f (should be this)\n", degrees_to_deg_min_sec(rad2deg(lla_target.lat))..., degrees_to_deg_min_sec(rad2deg(lla_target.lon))...)


# utm = UTM(789411.59, 3322824.08, 0.0, 47)
# lla_target = LatLonAlt(deg2rad(deg_min_sec_to_degrees(30, 0, 6.489)),
#                        deg2rad(deg_min_sec_to_degrees(101, 59, 59.805)), # E
#                        0.0)
# lla = convert(LatLonAlt, utm, INTERNATIONAL)
# @printf("%3d %1d %2.3f  %3d %1d %2.3f ← ", degrees_to_deg_min_sec(rad2deg(lla.lat))..., degrees_to_deg_min_sec(rad2deg(lla.lon))...)
# @printf("%2d %7.2f  %6.2f\n", utm.zone, utm.n, utm.e)
# @printf("%3d %1d %2.3f  %3d %1d %2.3f (should be this)\n", degrees_to_deg_min_sec(rad2deg(lla_target.lat))..., degrees_to_deg_min_sec(rad2deg(lla_target.lon))...)

# utm = UTM(200000.00, 1000000.00, 0.0, 31)
# lla_target = LatLonAlt(deg2rad(deg_min_sec_to_degrees(9, 2, 10.706)),
#                        deg2rad(deg_min_sec_to_degrees(0, 16, 17.099)), # E
#                        0.0)
# lla = convert(LatLonAlt, utm, INTERNATIONAL)
# @printf("%3d %1d %2.3f  %3d %1d %2.3f ← ", degrees_to_deg_min_sec(rad2deg(lla.lat))..., degrees_to_deg_min_sec(rad2deg(lla.lon))...)
# @printf("%2d %7.2f  %6.2f\n", utm.zone, utm.n, utm.e)
# @printf("%3d %1d %2.3f  %3d %1d %2.3f (should be this)\n", degrees_to_deg_min_sec(rad2deg(lla_target.lat))..., degrees_to_deg_min_sec(rad2deg(lla_target.lon))...)