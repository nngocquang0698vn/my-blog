---
title: "Listing the status of your branch protection in GitHub"
description: "Creating a command-line Go tool to list the branch protection status of your repositories."
date: 2023-02-03T17:16:11+0000
tags:
- blogumentation
- github
license_code: "Apache-2.0"
license_prose: "CC-BY-NC-SA-4.0"
image: https://media.jvt.me/36fd7d2a48.png
slug: github-branch-protection-report
---
I've recently been doing an audit of my branches across the repos I have on GitHub, and needed a way to list all the protection in place across various repos.

To make it easier, I've created [a Go tool](https://gitlab.com/tanna.dev/github-branch-protection), which can be installed like:

```sh
go install gitlab.com/tanna.dev/github-branch-protection@HEAD
```

Then, create a file i.e. `repos.txt` i.e.:

```
jamietanna/jamietanna
jamietanna/pages-testing
```

Then run:

```sh
github-branch-protection repos.txt
```

And it'll output a Tab Separated Value (TSV) formatted output, such as:

<table>
	<thead>
		<tr>
			<td>Organisation</td>
			<td>Repo</td>
			<td>Branch</td>
			<td>Branch exists?</td>
			<td>Branch protected?</td>
			<td>Any required status checks?</td>
			<td>Required status checks</td>
			<td>Strict status checks?</td>
			<td>Push restrictions?</td>
			<td>Admins included?</td>
			<td>Force pushes allowed?</td>
			<td>Deletions allowed?</td>
			<td>PR review required?</td>
			<td>CODEOWNERS required to review?</td>
			<td>Review bypasses allowed for?</td>
		</tr>
	</thead>
	<tr>
		<td>jamietanna</td>
		<td>jamietanna</td>
		<td>main</td>
		<td>true</td>
		<td>false</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
	</tr>
	<tr>
		<td>jamietanna</td>
		<td>jamietanna</td>
		<td>master</td>
		<td>false</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
	</tr>
	<tr>
		<td>jamietanna</td>
		<td>pages-testing</td>
		<td>main</td>
		<td>true</td>
		<td>true</td>
		<td>false</td>
		<td></td>
		<td>false</td>
		<td></td>
		<td>true</td>
		<td>false</td>
		<td>false</td>
		<td>true</td>
		<td>true</td>
		<td></td>
	</tr>
	<tr>
		<td>jamietanna</td>
		<td>pages-testing</td>
		<td>master</td>
		<td>false</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
	</tr>
</table>
