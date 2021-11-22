#!/bin/bash

set -eo pipefail

readonly thisDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly version="0.0.1"

readonly layoutHtml=$(cat << 'EOF'
<!doctype html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<title>%projectName% Status | %title%</title>
		%feedLink%
		<style>
			@font-face {
				font-family: 'Lato';
				font-style: normal;
				font-weight: 400;
				font-display: swap;
				src: local('Lato Regular'), url(data:font/woff2;base64,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) format('woff2');
				unicode-range: U+0000-00FF, U+0131, U+0152-0153, U+02BB-02BC, U+02C6, U+02DA, U+02DC, U+2000-206F, U+2074, U+20AC, U+2122, U+2191, U+2193, U+2212, U+2215, U+FEFF, U+FFFD;
			}

			* {
				box-sizing: border-box;
			}

			:root {
				--gutter: 1rem;
				--bg: #363636;
				--footer-bg: #282828;
				--footer-sidebar-border: rgba(64, 64, 64, 0.75);
				--footer-sidebar-bg: #202020;
				--color: #dddddd;
				--sidebar-border: rgba(64, 64, 64, 0.75);
				--link-color: #7493d7;
				--link-hover-color: #a6caff;
				--sidebar-link-hover: white;
				--sidebar-link-hover-bg: #33446e;
				--sidebar-bg: var(--footer-bg);
				--table-border: #6c6c6c;
				--table-head-bg: #565656;
				--text-ok: #45b245;
				--text-not-ok: #ee6565;
				--uptime-line-border: rgba(255, 255, 255, 0.75);
				--tab-bg: #494949;
				--tab-active-color: white;
				--bar-min-color: #4c91a4;
				--bar-avg-color: #9f9f9f;
				--bar-max-color: #b99764;

				font-size: 14px;
			}

			body {
				margin: 0;
				background-color: var(--bg);
				color: var(--color);
				font-family: Lato, sans-serif;
			}

			h1 {
				text-align: center;
				margin: 0;
				font-size: 3rem;
			}

			time[datetime].formatted {
				cursor: help;
				text-decoration: dotted underline;
			}

			hr {
				height: 0;
				margin: 1rem 0.5rem;
				border-top: 1px solid #101010;
				border-bottom: 1px solid #595959;
			}

			a {
				color: var(--link-color);
				text-decoration: none;
				transition: color ease-in 100ms;
			}

			a:hover {
				color: var(--link-hover-color);
				text-decoration: underline;
			}

			.container {
				display: flex;
				flex-direction: column;
				min-height: 100vh;
			}

			.upper {
				display: flex;
				flex: 1;
			}

			.content {
				flex: 1;
			}

			.content-main {
				padding: 1rem 2rem;
			}

			.content-header {
				text-shadow: 2px 2px 2px black;
			}

			.sidebar {
				display: flex;
				flex-direction: column;
				background-color: var(--sidebar-bg);
			}

			.sidebar a {
				display: block;
				padding: 0.5rem 0.75rem;
				transition: all ease-in 100ms;
				color: inherit;

				text-overflow: ellipsis;
				white-space: nowrap;
				overflow: hidden;

				border-top: 2px solid var(--sidebar-border);
				border-right: 2px solid var(--sidebar-border);
			}

			.sidebar li:last-child a {
				border-bottom: 2px solid var(--sidebar-border);
			}

			.sidebar a:hover,
			.sidebar .active a {
				color: var(--sidebar-link-hover);
				background-color: var(--sidebar-link-hover-bg);
				text-decoration: none;
			}

			.sidebar .active a {
				background-color: transparent;
				background-image: linear-gradient(to right, var(--sidebar-link-hover-bg), var(--bg));
				text-shadow: 1px 1px 1px black;
				border-right-color: var(--bg);
				font-variant: small-caps;
				font-weight: bold;
			}

			.sidebar .active a:before {
				content: "\25B8";
				margin-right: 0.25rem;
			}

			.list-unstyled {
				list-style: none;
				margin: 0;
				padding: 0;
			}

			.sidebar-ish {
				width: 15rem;
			}

			.sidebar .upper-border {
				border-right: 2px solid var(--sidebar-border);
				height: var(--gutter);
			}

			.sidebar .lower-border {
				border-right: 2px solid var(--sidebar-border);
				flex: 1;
			}

			.footer {
				background-color: var(--footer-bg);
				text-align: center;
				border-top: 2px solid var(--sidebar-border);
				font-size: 75%;
				box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.25);
				display: flex;
			}

			.footer .sidebar-ish {
				border-right: 2px solid var(--footer-sidebar-border);
				background-color: var(--footer-sidebar-bg);
			}

			.footer p {
				opacity: 0.5;
				transition: opacity 100ms linear;
				padding: 0.5rem;
				margin: 0;
			}

			.footer p:hover {
				opacity: 1;
			}

			.footer a {
				color: inherit;
			}

			.overview-summary {
				display: flex;
				max-width: 600px;
				margin: auto;
				align-items: center;
			}

			.overview-summary > * {
				flex: 1;
			}

			.overview-summary-icon svg {
				filter: drop-shadow(3px 5px 2px rgb(0 0 0 / 0.4));
			}

			.overview-summary-text {
				text-align: center;
				font-variant: small-caps;
			}

			.overview-summary-text header {
				font-size: 8vw;
				text-shadow: 3px 5px 2px rgba(0, 0, 0, 0.4);
			}

			.overview-summary-text p {
				font-size: 2.25vw;
				text-shadow: 1px 1px 1px black;
				margin: 0;
			}

			.text-ok {
				color: var(--text-ok);
				stroke: var(--text-ok);
			}

			.text-not-ok {
				color: var(--text-not-ok);
			}

			.text-ok circle,
			.text-ok path {
				stroke: var(--text-ok);
			}

			.text-not-ok circle,
			.text-not-ok path {
				stroke: var(--text-not-ok);
			}

			.recent-check-list {
				border-collapse: collapse;
				width: 100%;
				border: 1px solid var(--table-border);
				max-width: 1400px;
				margin: auto;
			}

			.recent-check-list th,
			.recent-check-list td {
				border: 1px solid var(--table-border);
				padding: 0.25rem 0.5rem;
			}

			.recent-check-list thead th {
				background-color: var(--table-head-bg);
			}

			.recent-check-list svg {
				max-height: 24px;
			}

			.recent-check-list tbody td {
				text-align: center;
			}

			.recent-check-list tbody td:nth-child(1) {
				text-align: left;
			}

			.overview-link {
				font-variant: small-caps;
				font-weight: bold;
			}

			.expected-status {
				opacity: 0.5;
			}

			.uptime-group {
				width: 100%;
			}
			.uptime-group th {
				text-align: right;
				padding-right: 10px;
			}

			.uptime-pct {
				font-family: monospace;
				color: #d5d5d5;
				text-shadow: 1px 1px 1px black;
				font-size: 1rem;
				padding-left: 10px;
			}

			.uptime-line {
				height: 20px;
				width: 100%;
				display: flex;
				border: 1px solid var(--uptime-line-border);
				box-shadow: 0 0 2px black;
				border-radius: 4px;
			}

			.uptime-segment {
				opacity: 0.75;
				transition: opacity linear 100ms;
				cursor: help;
				border-right: 1px solid var(--uptime-line-border);
			}

			.uptime-segment:hover {
				opacity: 1;
			}

			.uptime-segment.up {
				background-image: linear-gradient(to bottom, var(--text-ok), #3B733B);
			}

			.uptime-segment.down {
				background-image: linear-gradient(to bottom, var(--text-not-ok), #A64646);
			}

			.uptime-segment:first-child {
				border-top-left-radius: 4px;
				border-bottom-left-radius: 4px;
			}

			.uptime-segment:last-child {
				border-top-right-radius: 4px;
				border-bottom-right-radius: 4px;
				border-right: none;
			}

			.chart-container {
				background-color: rgba(128, 128, 128, 0.25);
				max-width: 800px;
				margin: 0 auto;
			}

			.bar-chart .bar rect {
				stroke: black;
				opacity: 0.75;
				transition: opacity linear 100ms;
			}

			.bar-chart .bar.min rect {
				fill: var(--bar-min-color);
			}

			.bar-chart .bar.max rect {
				fill: var(--bar-max-color);
			}

			.bar-chart .bar.avg rect {
				fill: var(--bar-avg-color);
			}

			.bar-chart .bar rect:hover {
				opacity: 1;
			}

			.bar-chart .axis-labels text {
				fill: white;
				stroke-width: 0;
			}

			.tab-content > * {
				display: none;
			}

			.chart-tabs {
				margin: auto;
				max-width: 800px;
			}

			.tab-header ul {
				display: flex;
				margin-left: 20px;
			}

			.tab-header li {
				border: 1px solid transparent;
				border-top-right-radius: 2px;
				border-top-left-radius: 2px;
			}

			.tab-header li a {
				display: block;
				padding: 5px 10px;
			}

			.tab-header li.active {
				font-weight: bold;
				background-color: var(--tab-bg);
				border-color: var(--tab-active-color);
				border-bottom-color: var(--tab-bg);
				margin-bottom: -1px;
			}

			.tab-header li.active a {
				color: var(--tab-active-color);
				text-decoration: none;
				font-weight: bold;
				text-shadow: 1px 1px 1px black;
			}

			.tab-content {
				border-top: 1px solid var(--tab-active-color);
			}

			.tab-content .active {
				display: block;
			}

			.not-ok-event {
				fill: var(--text-not-ok);
			}

		</style>
	</head>
	<body>
		<svg style="display: none" width="0" height="0" xmlns="http://www.w3.org/2000/svg">
			<symbol id="checkmark" viewBox="0 0 100 100">
				<path d="M 25 50 L 45 65 L 70 30" fill="transparent" stroke-width="10"/>
			</symbol>
			<symbol id="checkmark-circle" viewBox="0 0 100 100">
				<circle cx="50" cy="50" r="40" fill="transparent" stroke-width="5"/>
				<path d="M 25 50 L 45 65 L 70 30" fill="transparent" stroke-width="10"/>
			</symbol>
			<symbol id="times" viewBox="0 0 100 100">
				<path d="M 30 30 L 70 70 M 30 70 L 70 30" fill="transparent" stroke-width="10"/>
			</symbol>
			<symbol id="times-circle" viewBox="0 0 100 100">
				<circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="5"/>
				<path d="M 30 30 L 70 70 M 30 70 L 70 30" fill="transparent" stroke-width="10"/>
			</symbol>
		</svg>

		<div class="container">
			<div class="upper">
				<div class="sidebar-ish sidebar">
					<div class="upper-border"></div>
					<ul class="list-unstyled">
						%sidebarLinks%
					</ul>
					<div class="lower-border"></div>
				</div>
				<div class="content content-main">
					<h1 class="content-header">%header%</h1>
					<hr />
					%content%
				</div>
			</div>
			<div class="footer">
				<div class="sidebar-ish">
					<p>
						<a href="https://github.com/tmont/stanley">Stanley v<tt>%version%</tt></a>
					</p>
				</div>
				<div class="content">
					<p>
						last updated
						<time datetime="%lastUpdated%">%lastUpdated%</time>
					</p>
				</div>
			</div>
		</div>

		<script>
			(function() {
				const timeFormatter = new Intl.DateTimeFormat([], {
					dateStyle: 'long',
					timeStyle: 'short',
				});

				const relativeFormatter = new Intl.RelativeTimeFormat([], {
					numeric: 'auto',
					style: 'long',
				})

				const updateTime = (el) => {
					const isRelative = el.hasAttribute('data-relative');
					const date = new Date(el.getAttribute('datetime'));
					el.textContent = isRelative ? formatRelativeDate(date) : timeFormatter.format(date);
				}

				const updateTimes = () => {
					document.querySelectorAll('time[datetime]').forEach(updateTime);
				};

				const formatRelativeDate = (date) => {
					const elapsedMs = date.getTime() - Date.now();
					const elapsedAbs = Math.abs(elapsedMs);
					const oneS = 1000;
					const oneM = 60 * oneS;
					const oneH = 60 * oneM;
					const oneD = 24 * oneH;
					if (elapsedAbs < 61 * oneS) {
						return relativeFormatter.format(Math.round(elapsedMs / oneS), 'second');
					}

					if (elapsedAbs < oneM * 90) {
						return relativeFormatter.format(Math.round(elapsedMs / oneM), 'minute');
					}

					if (elapsedAbs < oneH * 36) {
						return relativeFormatter.format(Math.round(elapsedMs / oneH), 'hour');
					}

					return relativeFormatter.format(Math.round(elapsedMs / oneD), 'day');
				};

				document.querySelectorAll('time[datetime]').forEach((el) => {
					updateTime(el);
					el.classList.add('formatted');
					el.setAttribute('title', el.getAttribute('datetime'));
				});

				setInterval(updateTimes, 10000);

				document.querySelectorAll('.chart-tabs').forEach((el) => {
					const items = el.querySelectorAll('.tab-header li');
					const content = el.querySelector('.tab-content');

					el.querySelectorAll('.tab-header a').forEach((a) => {
						a.addEventListener('click', (e) => {
							e.preventDefault();
							items.forEach((li) => {
								li.classList.remove('active');
							});
							a.parentElement.classList.add('active');
							const target = a.getAttribute('data-target');
							content.querySelectorAll('.chart-container').forEach((div) => {
								div.classList.remove('active');
								if (div.classList.contains('chart-' + target)) {
									div.classList.add('active');
								}
							});
						});
					});
				});

				const zeroPad = x => x.toString().length < 2 ? `0${x}` : x;

				document.querySelectorAll('svg .axis-labels.x text').forEach((el) => {
					const time = el.textContent;
					let match;
					let newValue;

					const getTime = date => zeroPad(date.getHours()) + ':' + zeroPad(date.getMinutes());

					if (/^\d\d:\d\d$/.test(time)) {
						// last hour/day is just time
						newValue = getTime(new Date('2021-11-02T' + time + ':00.000Z'));
					} else if (match = /^(\d\d)\/(\d\d) (\d\d:\d\d)$/.exec(time)) {
						// last week/month
						const date = new Date(`2021-${match[1]}-${match[2]}T${match[3]}:00.000Z`);
						newValue = (date.getMonth() + 1) + '/' + date.getDate() + ' ' + getTime(date);
					}

					if (newValue) {
						el.textContent = newValue;
					}
				});
			}());
		</script>
	</body>
</html>

EOF
)

fgColor() {
	printf "\e[38;5;%dm" "$1"
}

bgColor() {
	printf "\e[48;5;%dm" "$1"
}

readonly yellow=$(fgColor 3)
readonly blue=$(fgColor 4)
readonly gray=$(fgColor 245)
readonly reset=$(printf "\e[0m")
readonly bold=$(printf "\e[1m")

errcho() {
	>&2 echo "$*"
}

color() {
	local color=$1
	shift
	echo "${color}$*${reset}"
}

getMillis() {
	perl -MTime::HiRes -e 'printf("%.0f",Time::HiRes::time()*1000)'
}

convertSecondsToMs() {
	# must divide by 1 so that scale actually works lul
	echo "$1" | cut -d, -f"$2" | awk '{ print "scale=0; (" $1 " * 1000) / 1" }' | bc
}

usage() {
	cat << EOF
Generates uptime status pages

Stanley reads in a config file and generates a static HTML website.
The config file is a simple text file where each line is a separate
check in the following format:

name,url,httpMethod,expectedStatusCode

e.g.

An Example,https://example.com,GET,200
Another Example,https://example.org,GET,200

Usage: ${bold}$0 --name <name> --base-url <url> [options]${reset}

Options:

  --help, -h        Show this message
  --name name       Name of the overall project/account
  --base-url url    Base URL for use in Atom feed (e.g. https://example.com)
  --output dir      Output directory for generated files (./dist)
  --db file         Path to the SQLite database (./stanley.sqlite)
  --config file     Path to config file (./config.txt)
EOF
}

main() {
	local projectName=
	local projectBaseUrl=
	local outputDir="${thisDir}/dist"
	local configFile="${thisDir}/config.txt"
	local dbFile="${thisDir}/stanley.sqlite"

	parseArgs() {
		while [[ $# -gt 0 ]]; do
			local key="$1"
			shift

			case "${key}" in
				--help|-h)
					usage
					exit
					;;
				--name)
					projectName="$1"
					shift
					;;
				--base-url)
					projectBaseUrl="$1"
					shift
					;;
				--output)
					outputDir="$1"
					shift
					;;
				--db)
					dbFile="$1"
					shift
					;;
				--config)
					configFile="$1"
					shift
					;;
				*)
					echo "unknown option \"${key}\""
					exit 1
					;;
			esac
		done
	}

	parseArgs "$@"

	if [[ -z "${projectName}" ]]; then
		echo "missing project name"
		exit 1
	fi

	if [[ -z "${projectBaseUrl}" ]]; then
		echo "missing project base URL"
		exit 1
	fi

	if [[ ! -f "${configFile}" ]]; then
		echo "config file does not exist at \"${configFile}\""
		exit 1
	fi

	local urls=()
	local line
	while IFS= read -r line; do
		line=$(echo "${line}" | sed -e 's/^[[:space:]]*//' | sed -e 's/[[:space:]]*$//')
		if [[ ${#line} != 0 ]]; then
			urls+=("${line}")
		fi
	done < "${configFile}"

	local checkExecId
	checkExecId=$(date +%s)

	local pendingQueriesFile
	pendingQueriesFile="$(mktemp)"

	mkdir -p "${outputDir}"

	if [[ ! -f "${dbFile}" ]]; then
		echo "${blue}initializing sqlite db...${reset}"
		sqlite3 "${dbFile}" << EOF
create table url_check (
	id integer primary key,
	name text not null unique,
	expected_status_code integer not null,
	http_method text not null,
	url text not null
);

create table check_result (
	id integer primary key,
	url_check_id integer not null
		constraint check_result_url_check_id_fk references url_check(id)
			on update cascade on delete restrict,
	exec_id integer not null,
	ok integer not null,
	url text not null,
	http_method text not null,
	sent_at text not null,
	time_elapsed_ms integer not null,
	time_connect_ms integer,
	time_lookup_ms integer,
	expected_status_code integer not null,
	actual_status_code integer not null,
	remote_ip text,
	remote_port integer,
	header_size integer,
	response_size integer
);

create index result_sent_at_index on check_result (sent_at);
create unique index check_result_url_check_exec on check_result (exec_id, url_check_id);
EOF
	fi

	getIsoDate() {
		date --iso-8601=seconds -u
	}

	processUrl() {
		set +e
		local method
		local expectedStatus
		local url
		local line=$1
		local ts
		local checkName
		ts=$(getIsoDate)
		checkName=$(echo "${line}" | cut -d ',' -f1)
		url=$(echo "${line}" | cut -d ',' -f2)
		method=$(echo "${line}" | cut -d ',' -f3)
		expectedStatus=$(echo "${line}" | cut -d ',' -f4)

		echo "${gray}sending ${method} to ${url}...${reset}"

		local extraArgs=()
		if [[ "${method}" = "HEAD" ]]; then
			extraArgs+=("-I")
		else
			extraArgs+=("-X" "${method}")
		fi

		local curlResult
		local millis
		millis=$(getMillis)
		curlResult=$(
			curl \
				--connect-timeout 10 \
				--max-time 30 \
				"${extraArgs[@]}" \
				-s \
				-o /dev/null \
				-w '%{response_code},%{remote_ip},%{remote_port},%{size_header},%{size_download},%{time_connect},%{time_namelookup},%{time_total}' \
				"${url}"
		)
		echo "${bold}${blue}${method} ${url}${reset} finished in $(($(getMillis) - millis))ms"

		local actualStatusCode
		local ip
		local port
		local connectTime
		local lookupTime
		local totalTime
		local headerSize
		local responseSize
		actualStatusCode=$(echo "${curlResult}" | cut -d, -f1)
		ip=$(echo "${curlResult}" | cut -d, -f2)
		port=$(echo "${curlResult}" | cut -d, -f3)
		headerSize=$(echo "${curlResult}" | cut -d, -f4)
		responseSize=$(echo "${curlResult}" | cut -d, -f5)
		connectTime=$(convertSecondsToMs "${curlResult}" 6)
		lookupTime=$(convertSecondsToMs "${curlResult}" 7)
		totalTime=$(convertSecondsToMs "${curlResult}" 8)
		local ok=0
		if [[ "${actualStatusCode}" = "${expectedStatus}" ]]; then
			ok=1
		fi

		cat << EOF >> "${pendingQueriesFile}"
insert into url_check (
	name,
	expected_status_code,
	http_method,
	url
) values (
	'${checkName//\'/\\\'}',
	${expectedStatus},
	'${method}',
	'${url}'
) on conflict (name) do update set
	expected_status_code=excluded.expected_status_code,
	http_method=excluded.http_method,
	url=excluded.url;

insert into check_result (
	url_check_id,
	exec_id,
	ok,
	url,
	http_method,
	sent_at,
	time_elapsed_ms,
	time_connect_ms,
	time_lookup_ms,
	expected_status_code,
	actual_status_code,
	remote_ip,
	remote_port,
	header_size,
	response_size
) values (
	(select id from url_check where name='${checkName//\'/\\\'}'),
	${checkExecId},
	${ok},
	'${url}',
	'${method}',
	'${ts}',
	${totalTime},
	${connectTime},
	${lookupTime},
	${expectedStatus},
	${actualStatusCode},
	'${ip}',
	${port},
	${headerSize},
	${responseSize}
);
EOF

		set -e
	}

	local url
	for url in "${urls[@]}"; do
		processUrl "${url}"
	done

	wait

	echo "${yellow}inserting data into sqlite...${reset}"
	sqlite3 "${dbFile}" < "${pendingQueriesFile}"
	rm "${pendingQueriesFile}"

	local checkmark="<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><use href=\"#checkmark\" /></svg>"
	local checkmarkCircle="<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><use href=\"#checkmark-circle\" /></svg>"
	local times="<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><use href=\"#times\" /></svg>"
	local timesCircle="<svg viewBox=\"0 0 100 100\" xmlns=\"http://www.w3.org/2000/svg\"><use href=\"#times-circle\" /></svg>"

	getSafeUrl() {
		echo -n "$1" | perl -p -e "s^://^-^" | perl -p -e "s^/^_^g" | perl -p -e "s/[^-\\w.~]/-/g"
	}

	generateCheckItemRowsFor() {
		fetch "
select
	'<tr>' ||
	'<td><time data-relative datetime=\"' || sent_at || '\">' || sent_at || '</time></td>' ||
	'<td><a target=\"_blank\" href=\"' || replace(url, '&', '&amp;') || '\">' || replace(url, '&', '&amp;') || '</a></td>' ||
	'<td><tt>' || http_method || '</tt></td>' ||
	(case when ok = 1
	    then '<td class=\"text-ok\">${checkmark}</td>'
	    else '<td class=\"text-not-ok\">${times}</td>'
	    end
    ) ||
	'<td><tt class=\"' || (case when ok = 1 then 'text-ok' else 'text-not-ok' end) || '\">' || actual_status_code ||
		(case when ok = 1 then '' else '<sub class=\"expected-status\">' || expected_status_code || '</sub>' end) || '</tt></td>' ||
	'<td>' || time_elapsed_ms || 'ms</td>' ||
	'<td><tt>' || remote_ip || ':' || remote_port || '</tt></td>' ||
	'</tr>'
	as html
from check_result
$1" "check items"
	}

	uptimeRowsQuery() {
		echo "
select
    ok,
    time,
	coalesce((julianday(lead(time) over win) - julianday(time)) * 86400, 0) as elapsed_s,
	coalesce((julianday(lead(time) over win) - julianday(time)) * 1440, 0) as elapsed_m,
	coalesce((julianday(lead(time) over win) - julianday(time)) * 24, 0) as elapsed_h,
	coalesce((julianday(lead(time) over win) - julianday(time)), 0) as elapsed_d,
	case when last_value(time) over win2 = first_value(time) over win2
        then 100
        else
		coalesce(
		    ((julianday(lead(time) over win) - julianday(time)) * 86400) /
		        ((julianday(last_value(time) over win2) - julianday(first_value(time) over win2)) * 86400),
		    0
	    ) * 100
    end as pct
from (
	select
		ok,
		time
	from (
		select
			ok,
			lag(ok) over win  as prevOk,
			lead(ok) over win as nextOk,
			time
		from (
			select
				min(ok) as ok,
				sent_at as time
			from check_result
			$1
			group by sent_at
		) data
			WINDOW win AS (ORDER BY time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
	)
	where ok != prevOk or prevOk is null or nextOk is null
)
WINDOW
    win AS (ORDER BY time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
	win2 AS (ORDER BY time ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)"
	}

	getOkElapsedTotal() {
	    local result

	    result=$(fetch "
select
    case
	     when elapsed_d > 2
		     then round(elapsed_d, 2) || 'd'
	     when elapsed_h > 2
		     then round(elapsed_h, 2) || 'h'
	     when elapsed_m > 2
		     then round(elapsed_m, 2) || 'm'
        else round(elapsed_s, 2) || 's'
    end as txt
from (
    select
        ok,
        sum(elapsed_d) as elapsed_d,
        sum(elapsed_h) as elapsed_h,
        sum(elapsed_m) as elapsed_m,
        sum(elapsed_s) as elapsed_s
    from (
        $(uptimeRowsQuery "$1")
    )
    where ok=$2
)")

        if [[ -z "${result}" ]]; then
            result="0s"
        fi

        echo "${result}"
	}

	generateUptimeLine() {
		echo '<tr>'
		echo "<th>$1</th>"
		echo '<td><div class="uptime-line">'

		fetch "
select
    '<div ' ||
    'class=\"uptime-segment ' || (case when ok = 1 then 'up' else 'down' end) || '\" ' ||
    'style=\"width: ' || pct || '%\" ' ||
    'title=\"' || (case when ok = 1 then 'up' else 'down' end) || ' @ ' || time || ' (' ||
    (case
	     when elapsed_d > 2
		     then round(elapsed_d, 2) || ' days'
	     when elapsed_h > 2
		     then round(elapsed_h, 2) || ' hours'
	     when elapsed_m > 2
		     then round(elapsed_m, 2) || ' minutes'
        else round(elapsed_s, 2) || ' seconds'
    end) ||
    ')\"' ||
    '></div>' as html
from (
	$(uptimeRowsQuery "$2")
)" "uptime line html"

		local uptimePctTotal
		local uptimeTotal
		local downtimeTotal
		uptimePctTotal=$(fetch "select round(sum(pct), 4) as pct from ($(uptimeRowsQuery "$2")) where ok=1" "pct total uptime")
		uptimeTotal=$(getOkElapsedTotal "$2" 1)
		downtimeTotal=$(getOkElapsedTotal "$2" 0)

		echo "</div></td>"
		echo "<td><span class=\"uptime-pct\">${uptimePctTotal}%</span></td>"
		echo "<td><span class=\"uptime-pct\"><span class=\"text-ok\">&uarr;${uptimeTotal}</span></span></td>"
		echo "<td><span class=\"uptime-pct\"><span class=\"text-not-ok\">&darr;${downtimeTotal}</span></span></td>"
		echo "</tr>"
	}

	generateUptimeLines() {
		local where=$1
		local col='<col style="width: 6rem" />'

		echo '<table class="uptime-group">'
		echo "<colgroup><col style=\"width: 10rem\" /><col />${col}${col}${col}</colgroup>"

		if [[ -z "${where}" ]]; then
			where="where "
		else
			where="${where} and "
		fi

		generateUptimeLine 'Last hour' "${where} sent_at > strftime('%Y-%m-%dT%H:%M:%S+00:00', datetime('now', '-1 hour'))"
		generateUptimeLine 'Last 24 hours' "${where} sent_at > strftime('%Y-%m-%dT%H:%M:%S+00:00', datetime('now', '-24 hour'))"
		generateUptimeLine 'Last 7 days' "${where} sent_at > strftime('%Y-%m-%dT%H:%M:%S+00:00', datetime('now', '-7 day'))"
		generateUptimeLine 'Last 30 days' "${where} sent_at > strftime('%Y-%m-%dT%H:%M:%S+00:00', datetime('now', '-30 day'))"
		generateUptimeLine 'Last year' "${where} sent_at > strftime('%Y-%m-%dT%H:%M:%S+00:00', datetime('now', '-1 year'))"
		generateUptimeLine 'All time' "$1"

		echo '</table>'
	}

	generateTimeSeriesBarChart() {
		echo "<div class=\"chart-container chart-$1 $3\">"

		fetch "$(
			cat << EOF
with temp as (
    select '$1' as time_preset
),
chart_info as (
	select
	    'seconds' as increment,
		case
		    when time_preset = 'prev-hour' then 1200
		    when time_preset = 'prev-day' then 1200
		    when time_preset = 'prev-week' then 1176
		    when time_preset = 'prev-month' then 1200
		    when time_preset = 'prev-year' then 1196
		end as chart_width,
	    case
		    when time_preset = 'prev-hour' then 60
		    when time_preset = 'prev-day' then 1800
		    when time_preset = 'prev-week' then 10800
		    when time_preset = 'prev-month' then 43200
		    when time_preset = 'prev-year' then 604800
		end as interval,
	    case
		    when time_preset = 'prev-hour' then 60
		    when time_preset = 'prev-day' then 48
		    when time_preset = 'prev-week' then 56
		    when time_preset = 'prev-month' then 60
		    when time_preset = 'prev-year' then 52
		end as max_items,
	    case
		    when time_preset = 'prev-hour' then '%H:%M'
		    when time_preset = 'prev-day' then '%H:%M'
		    when time_preset = 'prev-week' then '%m/%d %H:%M'
		    when time_preset = 'prev-month' then '%m/%d %H:%M'
		    when time_preset = 'prev-year' then '%Y-%m-%d'
		end as date_format
	from temp
),
time_list as (
    with ct as (
	    select
		    cast(strftime('%s', datetime('now')) - (strftime('%s', datetime('now')) % chart_info.interval) as integer) as time
	    from chart_info
	    union all
	    select
		    cast(strftime('%s', datetime(time - chart_info.interval, 'unixepoch')) as integer) as time
	    from ct, chart_info
	    limit (select max_items from chart_info)
    ) select * from ct order by time
),
x_axis as (
    with cte as (select time, row_number() over (order by time) as num from time_list)
	select
	    (select strftime(chart_info.date_format, datetime(time, 'unixepoch')) from cte where num = 1) as step0,
		(select strftime(chart_info.date_format, datetime(time, 'unixepoch')) from cte where num = (chart_info.max_items / 4)) as step1,
	    (select strftime(chart_info.date_format, datetime(time, 'unixepoch')) from cte where num = (chart_info.max_items / 2)) as step2,
	    (select strftime(chart_info.date_format, datetime(time, 'unixepoch')) from cte where num = (chart_info.max_items / 4 * 3)) as step3,
	    (select strftime(chart_info.date_format, datetime(time, 'unixepoch')) from cte where num = chart_info.max_items) as step4
    from chart_info
),
chart as (
    select
        (chart_info.chart_width / 5) as chart_offset_x,
	    (chart_info.chart_width * 9 / 16 / 5) as chart_offset_y,
	    chart_info.chart_width as chart_width,
        (chart_info.chart_width * 9 / 16) as chart_height,
        (chart_info.chart_width / chart_info.max_items) as bar_width
    from chart_info
),
box as (
    select
        chart_width + (chart_offset_x * 2) as box_width,
        chart_height + (chart_offset_y * 2) as box_height
    from chart
),
time_info as (
	select
        time,
		row_number() over (order by time) as row_num,
        max(ok) as ok,
        max(elapsed_ms_avg) as elapsed_ms_avg,
        max(elapsed_ms_max) as elapsed_ms_max,
        max(elapsed_ms_min) as elapsed_ms_min,
        max(count) as count
    from (
	    select
		    time_list.time       as time,
		    min(ok)              as ok,
		    avg(time_elapsed_ms) as elapsed_ms_avg,
		    max(time_elapsed_ms) as elapsed_ms_max,
		    min(time_elapsed_ms) as elapsed_ms_min,
		    count(*)             as count
	    from time_list, chart_info
		inner join check_result
			on (strftime('%s', sent_at) - (strftime('%s', sent_at) % chart_info.interval)) = time_list.time
			$2
	    group by 1
	    union all
	    select
		    time,
		    null as ok,
		    null as elapsed_ms_avg,
		    null as elapsed_ms_max,
		    null as elapsed_ms_min,
		    0    as count
	    from time_list
    )
    group by 1
    order by 1
),
y_axis as (
    select
        coalesce((max(elapsed_ms_max) + (100 - (max(elapsed_ms_max) % 100))), 100) as y_max,
        coalesce((min(elapsed_ms_min) - (min(elapsed_ms_min) % 1000)), 0) as y_min
    from time_info
),
bar_values as (
    select
        time_info.*,
        max(5, coalesce((time_info.elapsed_ms_max / cast((y_max - y_min) as float) * chart_height), 0)) as max,
        max(5, coalesce((time_info.elapsed_ms_min / cast((y_max - y_min) as float) * chart_height), 0)) as min,
        max(5, coalesce((time_info.elapsed_ms_avg / cast((y_max - y_min) as float) * chart_height), 0)) as avg,
        chart_offset_x + (row_num - 1) * bar_width as xStart,
	    chart_offset_y + chart_height as yStart
    from y_axis, time_info, chart
),
bar_svg as (
    select
	    '<g class="bar min"><rect x="' || xStart || '" y="' || (yStart - bar_values.min) || '" width="' || bar_width || '" height="' || bar_values.min || '" /></g>' as svg_min,
        case when bar_values.min != bar_values.avg then
            '<g class="bar avg"><rect x="' || xStart || '" y="' || (yStart - bar_values.avg) || '" width="' || bar_width || '" height="' || (bar_values.avg - bar_values.min) || '" /></g>'
            else ''
            end as svg_avg,
	    case
		    when bar_values.avg != bar_values.max
			    then '<g class="bar max"><rect x="' || xStart || '" y="' || (yStart - bar_values.max) || '" width="' || bar_width || '" height="' || (bar_values.max - bar_values.avg) || '" /></g>'
	        else ''
	        end as svg_max,
		case when ok = 0
            then '<polygon class="not-ok-event" fill="red" stroke="black" points="' ||
                 (xStart + (bar_width / 2) - 10) || ',' || (chart_offset_y - 20) || ' ' ||
                 (xStart + (bar_width / 2) + 10) || ',' || (chart_offset_y - 20) || ' ' ||
                 (xStart + (bar_width / 2)) || ',' || (chart_offset_y - 5) ||
                '" />'
            else ''
            end as svg_ok_event,
        bar_values.*
	from chart, y_axis, bar_values
)
select
	'<svg class="bar-chart elapsed-chart" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ' || box_width || ' ' || box_height || '">' ||
	'<style>' ||
		'.axis-labels text { font-family: monospace; font-size: 18px; }' ||
		'.grid-lines line { stroke: rgba(255, 255, 255, 0.5); }' ||
		'.axis-title { font-family: Lato; font-size: 36px; fill: white; }' ||
	'</style>' ||

    -- y-axis grid lines
    '<g class="grid-lines y">' ||
	    '<line stroke="white" x1="' || (chart_offset_x) || '" x2="' || (chart_offset_x + chart_width) || '" y1="' || (chart_offset_y + (chart_height / 4 * 3)) || '" y2="' || (chart_offset_y + (chart_height / 4 * 3)) || '" />' ||
	    '<line stroke="white" x1="' || (chart_offset_x) || '" x2="' || (chart_offset_x + chart_width) || '" y1="' || (chart_offset_y + (chart_height / 4 * 2)) || '" y2="' || (chart_offset_y + (chart_height / 4 * 2)) || '" />' ||
	    '<line stroke="white" x1="' || (chart_offset_x) || '" x2="' || (chart_offset_x + chart_width) || '" y1="' || (chart_offset_y + (chart_height / 4)) || '" y2="' || (chart_offset_y + (chart_height / 4)) || '" />' ||
	    '<line stroke="white" x1="' || (chart_offset_x) || '" x2="' || (chart_offset_x + chart_width) || '" y1="' || (chart_offset_y) || '" y2="' || (chart_offset_y) || '" />' ||
    '</g>' ||

	group_concat(bar_svg.svg_max, '') ||
	group_concat(bar_svg.svg_avg, '') ||
	group_concat(bar_svg.svg_min, '') ||
	group_concat(bar_svg.svg_ok_event, '') ||

	-- y-axis
	'<path class="axis" d="M ' || chart_offset_x || ' ' || chart_offset_y || ' L ' || chart_offset_x || ' ' || (chart_offset_y + chart_height) || '" fill="black" stroke="black" />' ||
	-- y-axis labels
	'<g class="axis-labels y">' ||
		'<text text-anchor="end" dominant-baseline="middle" x="' || (chart_offset_x - 10) || '" y="' || (chart_offset_y + chart_height) || '">' || y_min || '</text>' ||
	    '<text text-anchor="end" dominant-baseline="middle" x="' || (chart_offset_x - 10) || '" y="' || (chart_offset_y + (chart_height / 4 * 3)) || '">' || (y_min + (((y_max - y_min) / 4))) || '</text>' ||
	    '<text text-anchor="end" dominant-baseline="middle" x="' || (chart_offset_x - 10) || '" y="' || (chart_offset_y + (chart_height / 4 * 2)) || '">' || (y_min + (((y_max - y_min) / 4 * 2))) || '</text>' ||
	    '<text text-anchor="end" dominant-baseline="middle" x="' || (chart_offset_x - 10) || '" y="' || (chart_offset_y + (chart_height / 4)) || '">' || (y_min + (((y_max - y_min) / 4 * 3))) || '</text>' ||
	    '<text text-anchor="end" dominant-baseline="middle" x="' || (chart_offset_x - 10) || '" y="' || (chart_offset_y) || '">' || y_max || '</text>' ||
    '</g>' ||
    -- y-axis title
    '<text text-anchor="middle" transform="rotate(-90, ' || (chart_offset_x / 2) || ', ' || (chart_offset_y + (chart_height / 2)) || ')" class="axis-title y" x="' || (chart_offset_x / 2) || '" y="' || (chart_offset_y + (chart_height / 2)) || '">Response time (ms)</text>' ||

	-- x-axis
	'<path class="axis" d="M ' || chart_offset_x || ' ' || (chart_offset_y + chart_height) || ' L ' || (chart_offset_x + chart_width) || ' ' || (chart_offset_y + chart_height) || '" fill="black" stroke="black" />' ||

	-- x-axis labels
	'<g class="axis-labels x">' ||
		'<text text-anchor="end" transform="rotate(-60,' || (chart_offset_x + 5) || ',' || (chart_offset_y + chart_height + 15) || ')" x="' || (chart_offset_x + 5) || '" y="' || (chart_offset_y + chart_height + 15) || '">' || x_axis.step0 || '</text>' ||
		'<text text-anchor="end" transform="rotate(-60,' || (chart_offset_x + 5 + (chart_width / 4)) || ',' || (chart_offset_y + chart_height + 15) || ')" x="' || (chart_offset_x + 5 + (chart_width / 4)) || '" y="' || (chart_offset_y + chart_height + 15) || '">' || x_axis.step1 || '</text>' ||
		'<text text-anchor="end" transform="rotate(-60,' || (chart_offset_x + 5 + (chart_width / 2)) || ',' || (chart_offset_y + chart_height + 15) || ')" x="' || (chart_offset_x + 5 + (chart_width / 2)) || '" y="' || (chart_offset_y + chart_height + 15) || '">' || x_axis.step2 || '</text>' ||
		'<text text-anchor="end" transform="rotate(-60,' || (chart_offset_x + 5 + (chart_width / 4 * 3)) || ',' || (chart_offset_y + chart_height + 15) || ')" x="' || (chart_offset_x + 5 + (chart_width / 4 * 3)) || '" y="' || (chart_offset_y + chart_height + 15) || '">' || x_axis.step3 || '</text>' ||
		'<text text-anchor="end" transform="rotate(-60,' || (chart_offset_x + 5 + chart_width) || ',' || (chart_offset_y + chart_height + 15) || ')" x="' || (chart_offset_x + 5 + chart_width) || '" y="' || (chart_offset_y + chart_height + 15) || '">' || x_axis.step4 || '</text>' ||
	'</g>' ||

	'</svg>' as svg
from bar_svg, box, chart, y_axis, x_axis
EOF
		)" "chart svg"
		echo "</div>"
	}

	generateChartTabs() {
		cat << EOF
<div class="chart-tabs">
	<div class="tab-header">
		<ul class="list-unstyled">
			<li class="active"><a href="#" data-target="prev-hour">Last hour</a></li>
			<li><a href="#" data-target="prev-day">Last 24 hours</a></li>
			<li><a href="#" data-target="prev-week">Last 7 days</a></li>
			<li><a href="#" data-target="prev-month">Last 30 days</a></li>
			<li><a href="#" data-target="prev-year">Last year</a></li>
		</ul>
	</div>
	<div class="tab-content">
		$(generateTimeSeriesBarChart "prev-hour" "$1" "active")
		$(generateTimeSeriesBarChart "prev-day" "$1")
		$(generateTimeSeriesBarChart "prev-week" "$1")
		$(generateTimeSeriesBarChart "prev-month" "$1")
		$(generateTimeSeriesBarChart "prev-year" "$1")
	</div>
</div>
EOF
	}

	generateFeedXML() {
		fetch "
select
	'<?xml version=\"1.0\" encoding=\"utf-8\"?>' ||
	'<feed xmlns=\"http://www.w3.org/2005/Atom\">' ||
		'<title>Stanley Status - $1</title>' ||
		'<link rel=\"self\" href=\"$2/feed.xml\" />' ||
		'<link rel=\"via\" href=\"$2\" />' ||
		'<generator uri=\"https://github.com/tmont/stanley\">Stanley</generator>' ||
		'<id>stanley-status-$1</id>' ||
		'<updated>' || strftime('%Y-%m-%dT%H:%M:%S+00:00', datetime('now')) || '</updated>' ||
		coalesce(group_concat(entry_xml, ''), '') ||
	'</feed>'
from (
	select
		u.id,
		u.name,
		u.url,
		results.time,
		results.ok,
	    '<entry>' ||
	        '<title>' || name || ' is ' || (case when ok = 1 then 'up' else 'down' end) || '</title>' ||
	        '<link rel=\"alternate\" href=\"' || url || '\" />' ||
	        '<published>' || strftime('%Y-%m-%dT%H:%M:%S+00:00', datetime('now')) || '</published>' ||
	        '<updated>' || time || '</updated>' ||
	        '<id>' || u.id || '-' || time || '</id>' ||
	        '<content type=\"text\">The uptime status of ' || name || ' (' || url || ') has changed. Visit $2/check-' || id || '.html for more details.' || '</content>' ||
	    '</entry>' as entry_xml
	from (
		select
			url_check_id,
			time,
			ok,
			lag(ok) over win as prevOk
		from (
			select
				url_check_id,
				min(ok) as ok,
				sent_at as time
			from check_result
			group by url_check_id, time
		) data
			WINDOW win AS (ORDER BY time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
	) results
	inner join url_check u
		on u.id = results.url_check_id
	where ok != prevOk
    order by time desc
)" "feed xml"
	}

	generateOverviewContent() {
		local icon="${checkmarkCircle}"
		local numUp=0
		local numDown=
		local text="OK"
		local textCls="text-ok"

		numUp=$(fetch "select count(*) from check_result where ok = 1 and exec_id = ${checkExecId}" "count ok=1")
		numDown=$(fetch "select count(*) from check_result where ok = 0 and exec_id = ${checkExecId}" "count ok=0")

		if [[ "${numDown}" -gt 0 ]]; then
			icon="${timesCircle}"
			text="Error"
			textCls="text-not-ok"
		fi

		cat << EOF
<div class="overview-summary">
	<div class="overview-summary-icon ${textCls}">
		${icon}
	</div>
	<div class="overview-summary-text">
		<header class="${textCls}">${text}</header>
		<p>
			<strong>${numUp}</strong> up
			/
			<strong>${numDown}</strong> down
		</p>
	</div>
</div>
$(generateUptimeLines "")
<hr />
$(generateChartTabs "")
<hr />
<table class="recent-check-list">
	<thead>
		<tr>
			<th>Date</th>
			<th>URL</th>
			<th>Method</th>
			<th>OK</th>
			<th>Status</th>
			<th>Time</th>
			<th>IP</th>
		</tr>
	</thead>
	<tbody>
		$(generateCheckItemRowsFor "where exec_id = '${checkExecId}' order by ok, url")
	</tbody>
</table>
EOF
	}

	generateSidebarLinks() {
		local check
		local active="$1"

		local cls=
		if [[ "${active}" = "@overview" ]]; then
			cls=" class=\"active\""
		fi
		echo " <li${cls}><a href=\"./index.html\">Overview</a></li>"

		local checkNames
		checkNames=$(echo "${checks}" | cut -f2)

		IFS=$'\n'
		for check in ${checks}; do
			local cls=""
			local checkId
			local checkName
			checkId=$(echo "${check}" | cut -f1)
			checkName=$(echo "${check}" | cut -f2)

			if [[ "${active}" = "${checkId}" ]]; then
				cls=" class=\"active\""
			fi

			echo "<li${cls}><a href=\"./check-${checkId}.html\">${checkName}</a></li>"
		done
	}

	replaceValue() {
		perl -p -i -e "s^%$1%^$2^" "$3"
	}

	fetch() {
#		local start=$(getMillis)
		sqlite3 -separator $'\t' "${dbFile}" "$1"
#		errcho "[$2]: query finished in $(($(getMillis) - start))ms"
	}

	# generate overview html page
	local indexFile="${outputDir}/index.html"

	local checks
	checks=$(fetch "select id, name from url_check order by id" "url_checks")

	local start
	start=$(getMillis)

	echo -n "generating ${yellow}feed.xml${reset}... "
	generateFeedXML "${projectName}" "${projectBaseUrl}" > "${outputDir}/feed.xml"
	echo "done in $(($(getMillis) - start))ms"

	start=$(getMillis)

	echo -n "generating ${yellow}$(basename "${indexFile}")${reset}... "

	echo "${layoutHtml}" > "${indexFile}"

	replaceValue "content" "$(generateOverviewContent)" "${indexFile}"
	replaceValue "projectName" "${projectName}" "${indexFile}"
	replaceValue "title" "Overview" "${indexFile}"
	replaceValue "header" "Overview" "${indexFile}"
	replaceValue "lastUpdated" "$(getIsoDate)" "${indexFile}"
	replaceValue "sidebarLinks" "$(generateSidebarLinks "@overview")" "${indexFile}"
	replaceValue "feedLink" "<link rel=\"alternate\" type=\"application/atom+xml\" href=\"./feed.xml\" />" "${indexFile}"
	replaceValue "version" "${version}" "${indexFile}"

	echo "done in $(($(getMillis) - start))ms"

	# generate html page for each URL
	local check
	IFS=$'\n'
	for check in ${checks}; do
		local checkId
		local checkName
		checkId=$(echo "${check}" | cut -f1)
		checkName=$(echo "${check}" | cut -f2)

		local urlFile
		urlFile="${outputDir}/check-${checkId}.html"
		local start
		start=$(getMillis)
		echo -n "generating ${yellow}$(basename "${urlFile}")${reset}... "

		echo "${layoutHtml}" > "${urlFile}"

		local mostRecentOk
		mostRecentOk=$(fetch "
select
	ok
from check_result
where url_check_id=${checkId}
order by sent_at desc
limit 1" "most recent ok")

		local icon="${checkmarkCircle}"
		local text="UP"
		local textCls="text-ok"

		if [[ "${mostRecentOk}" != "1" ]]; then
			icon="${timesCircle}"
			text="DOWN"
			textCls="text-not-ok"
		fi

		local content

		content="
<div class=\"overview-summary\">
	<div class=\"overview-summary-icon ${textCls}\">
		${icon}
	</div>
	<div class=\"overview-summary-text\">
		<header class=\"${textCls}\">${text}</header>
	</div>
</div>
$(generateUptimeLines "where url_check_id = ${checkId}")
<hr />
$(generateChartTabs "and url_check_id = ${checkId}")
<hr />
<table class=\"recent-check-list\">
	<thead>
		<tr>
			<th>Date</th>
			<th>URL</th>
			<th>Method</th>
			<th>OK</th>
			<th>Status</th>
			<th>Time</th>
			<th>IP</th>
		</tr>
	</thead>
	<tbody>
		$(generateCheckItemRowsFor "where url_check_id = ${checkId} order by sent_at desc limit 100")
	</tbody>
</table>"

		replaceValue "projectName" "${projectName}" "${urlFile}"
		replaceValue "content" "${content}" "${urlFile}"
		replaceValue "title" "${checkName}" "${urlFile}"
		replaceValue "header" "${checkName}" "${urlFile}"
		replaceValue "lastUpdated" "$(getIsoDate)" "${urlFile}"
		replaceValue "sidebarLinks" "$(generateSidebarLinks "${checkId}")" "${urlFile}"
		replaceValue "feedLink" "" "${urlFile}"
		replaceValue "version" "${version}" "${urlFile}"

		echo "done in $(($(getMillis) - start))ms"
	done

	echo "all done in ${SECONDS}s"
}

main "$@"
