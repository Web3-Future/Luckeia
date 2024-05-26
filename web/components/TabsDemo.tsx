"use client"
import { Button } from "@/components/ui/button"
import React, { useState } from 'react'
import {
    Card,
    CardContent,
    CardDescription,
    CardFooter,
    CardHeader,
    CardTitle,
} from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
    Tabs,
    TabsContent,
    TabsList,
    TabsTrigger,
} from "@/components/ui/tabs"


export default function TabsDemo() {
    function handleClick() {
        alert(1);
    }
    const [address, setAddress] = useState('');

    const handleAddressChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        if (/^0x[a-fA-F0-9]*$/.test(value) || value === '') {
            setAddress(value);
        }
    };

    return (
        <Tabs defaultValue="s1" className="w-[400px]">
            <TabsList className="grid w-full grid-cols-4">
                <TabsTrigger value="s1">Random Prize</TabsTrigger>
                <TabsTrigger value="s2">Lucky List</TabsTrigger>
                <TabsTrigger value="s3">Lucky Num</TabsTrigger>
                <TabsTrigger value="c1">Custom</TabsTrigger>
            </TabsList>
            <TabsContent value="s1">
                <Card>
                    <CardHeader>
                        {/* <CardTitle>Account</CardTitle> */}
                        <CardDescription>
                            Enter the total amount, number of winners, and addresses. The system generates a winner list and directly sends the token to the winners. 🍀
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-2">
                        <div className="space-y-1">
                            <Label htmlFor="amount1">Amount</Label>
                            <Input id="amount1" type="number" step="0.01" defaultValue="" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="maxWinners">Maximum Winners</Label>
                            <Input id="maxWinners1" type="number" defaultValue="" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="address">Participants</Label>
                            <Input id="participants1" type="text" defaultValue="" placeholder="0x1, 0x2, ..., etc" />
                        </div>
                    </CardContent>

                    <CardFooter>
                        <Button onClick={handleClick}>Start Draw</Button>
                    </CardFooter>
                </Card>
            </TabsContent>
            <TabsContent value="s2">
                <Card>
                    <CardHeader>
                        {/* <CardTitle>s2</CardTitle> */}
                        <CardDescription>
                            Enter number of winners, and addresses. The system generates ranked  winner list.
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-2">

                        <div className="space-y-1">
                            <Label htmlFor="maxWinners">Maximum Winners</Label>
                            <Input id="maxWinners2" type="number" defaultValue="" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="address">Participants</Label>
                            <Input id="participants2" type="text" defaultValue="" placeholder="0x1, 0x2, ..., etc" />
                        </div>
                    </CardContent>
                    <CardFooter>
                        <Button>Start Draw</Button>
                    </CardFooter>
                </Card>
            </TabsContent>
            <TabsContent value="s3">
                <Card>
                    <CardHeader>
                        {/* <CardTitle>s3</CardTitle> */}
                        <CardDescription>
                            Enter a range of numbers. The system generates one lucky number.
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-2">
                        <div className="space-y-1">
                            <Label htmlFor="start">Start Number</Label>
                            <Input id="start" type="number" />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="end">End Number</Label>
                            <Input id="end" type="number" />
                        </div>
                    </CardContent>
                    <CardFooter>
                        <Button>Start Draw</Button>
                    </CardFooter>
                </Card>
            </TabsContent>
            <TabsContent value="c1">
                <Card>
                    <CardHeader>
                        <CardTitle>Custom</CardTitle>
                        <CardDescription>
                            Custom strategy
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-2">
                        <div className="space-y-1">
                            <Label htmlFor="contractAddress">Contract Address</Label>
                            <Input id="contractAddress" type="text" placeholder="0x..." />
                        </div>
                        <div className="space-y-1">
                            <Label htmlFor="functions">Functions(coming soon)</Label>
                            <Input id="functions" type="text" placeholder="Parse ABI through address." />
                        </div>
                    </CardContent>
                    <CardFooter>
                        <Button>Start Draw</Button>
                    </CardFooter>
                </Card>
            </TabsContent>
        </Tabs>
    )
}
